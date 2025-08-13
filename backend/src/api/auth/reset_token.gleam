import api/auth/access_token
import api/auth/login
import api/auth/refresh_token
import api/exceptions
import api/middleware.{type Context}
import gleam/http.{Get, Post}
import wisp.{type Request, type Response}

pub fn refresh_token(req: Request, ctx: Context) {
  case req.method {
    Post -> refresh_token_post(req, ctx)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn refresh_token_post(req: Request, ctx: Context) -> Response {
  use json <- wisp.require_json(req)
  let tokens = login.decode_tokens(json)

  case tokens {
    //TODO should error 400
    Error(_) ->
      middleware.respond_with_exception(401, exceptions.NotAuthenticated)
    Ok(auth) -> {
      let user =
        refresh_token.get_user_from_refresh_token(auth.refresh_token, ctx)
      case user {
        Ok(user) -> login.generate_tokens(user, ctx)
        _ -> middleware.respond_with_exception(401, exceptions.NotAuthenticated)
      }
    }
  }
}
