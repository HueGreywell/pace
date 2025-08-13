import api/auth/access_token
import api/auth/login
import api/auth/register
import api/auth/reset_token
import api/exceptions
import api/middleware.{type Context, middleware}
import config/cors as apps_cors
import cors_builder as cors
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- middleware(req)
  use req <- cors.wisp_middleware(req, apps_cors.setup_cors())

  case wisp.path_segments(req) {
    ["login"] -> login.on_login(req, ctx)
    ["register"] -> register.on_register(req, ctx)
    ["refresh-token"] -> reset_token.refresh_token(req, ctx)
    //["logout"] -> logout.logout_view(req, ctx)
    //["routes"] -> guarded(req, ctx, login.on_login)
    //["refresh-token"] -> refresh_token.refresh_token_view(req, ctx)
    _ -> wisp.not_found()
  }
}

fn guarded(
  req: Request,
  context: Context,
  route_handler: fn(Request, Context) -> Response,
) -> Response {
  let auth_header = access_token.get_auth_header(req)
  case auth_header {
    #(False, _) ->
      middleware.respond_with_exception(401, exceptions.NotAuthenticated)
    #(True, token) -> {
      case access_token.verify_access_token(token, context.secret_key) {
        False ->
          middleware.respond_with_exception(500, exceptions.NotAuthenticated)
        True -> route_handler(req, context)
      }
    }
  }
}
