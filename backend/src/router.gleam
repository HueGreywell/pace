import config/cors as c
import controllers/login
import controllers/refresh_token
import controllers/register
import cors_builder as cors
import shork
import utils/context.{Context}
import wisp.{type Request, type Response}

pub fn handle_request(
  req: Request,
  db: shork.Connection,
  secret_key: String,
) -> Response {
  use req <- middleware(req)
  use req <- cors.wisp_middleware(req, c.setup_cors())

  let ctx = Context(req:, db:, secret_key:)

  case wisp.path_segments(req) {
    ["login"] -> login.handler(ctx)
    ["register"] -> register.handler(ctx)
    ["refresh-token"] -> refresh_token.refresh_token(req, ctx)
    //["logout"] -> logout.logout_view(req, ctx)
    _ -> wisp.not_found()
  }
}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  handle_request(req)
}
// fn guarded(
//   req: Request,
//   context: Context,
//   route_handler: fn(Request, Context) -> Response,
// ) -> Response {
//   let auth_header = access_token.get_auth_header(req)
//   case auth_header {
//     #(False, _) ->
//       middleware.respond_with_exception(401, exceptions.NotAuthenticated)
//     #(True, token) -> {
//       case access_token.verify_access_token(token, context.secret_key) {
//         False ->
//           middleware.respond_with_exception(500, exceptions.NotAuthenticated)
//         True -> route_handler(req, context)
//       }
//     }
//   }
// }
