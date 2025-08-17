import dtos/auth_dto.{decode_tokens}
import gleam/http.{Get, Post}
import services/refresh_token.{generate_tokens, get_user_from_refresh_token}
import utils/context.{type Context}
import utils/exception_response.{respond_with_error}
import utils/exceptions.{NotAuthenticated}
import wisp.{type Response}

pub fn handler(ctx: Context) {
  case ctx.req.method {
    Post -> refresh_token_post(ctx)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn refresh_token_post(ctx: Context) -> Response {
  use json <- wisp.require_json(ctx.req)
  let tokens = decode_tokens(json)

  case tokens {
    Error(_) -> respond_with_error(NotAuthenticated)
    Ok(auth) -> {
      let user = get_user_from_refresh_token(auth.refresh_token, ctx)
      case user {
        Error(_) -> respond_with_error(NotAuthenticated)
        Ok(user) -> {
          let auth = generate_tokens(user, ctx)
          case auth {
            Error(_) -> respond_with_error(NotAuthenticated)
            Ok(auth) -> {
              let json = auth_dto.encode_tokens(auth)
              wisp.ok() |> wisp.json_body(json)
            }
          }
        }
      }
    }
  }
}
