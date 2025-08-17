import services/access_token
import utils/context.{type Context}
import utils/exceptions.{type Exception, NotAuthenticated}

pub fn auth_guard(ctx: Context) -> Result(String, Exception) {
  let #(status, token) = access_token.get_auth_header(ctx.req)

  case status {
    False -> Error(NotAuthenticated)
    True -> {
      let is_authenticated =
        access_token.verify_access_token(token, ctx.secret_key)
      case is_authenticated {
        False -> Error(NotAuthenticated)
        True -> access_token.get_user_id(token, ctx.secret_key)
      }
    }
  }
}
