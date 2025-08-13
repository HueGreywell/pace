import api/auth/access_token
import api/auth/refresh_token
import api/exceptions
import api/middleware.{type Context, respond_with_exception}
import convert as c
import convert/json as cjson
import domain/login/login.{decode_login}
import domain/user/user
import gleam/dynamic
import gleam/dynamic/decode
import gleam/json
import gleam/string_tree
import wisp.{type Request}

pub fn on_login(req: Request, context: Context) {
  use json <- wisp.require_json(req)
  case decode_login(json) {
    Error(error) -> respond_with_exception(400, error)
    Ok(login) -> {
      let user = login.get_user(login, context.db)
      case user {
        Ok(user) -> generate_tokens(user, context)
        Error(error) -> respond_with_exception(400, error)
      }
    }
  }
}

pub fn generate_tokens(user: user.User, ctx: Context) {
  let access_token = access_token.create_access_token(ctx.secret_key, user.id)
  let refresh_token = refresh_token.create_refresh_token(user.id, ctx)
  case refresh_token {
    Error(error) -> respond_with_exception(500, error)
    Ok(refresh_token) -> {
      let auth_response = encode_tokens(refresh_token, access_token)
      wisp.ok()
      |> wisp.json_body(auth_response)
    }
  }
}

pub type AuthResponse {
  AuthResponse(refresh_token: String, access_token: String)
}

pub fn decode_tokens(
  json: dynamic.Dynamic,
) -> Result(AuthResponse, exceptions.Exception) {
  let decoder = {
    use refresh_token <- decode.field("refresh_token", decode.string)
    use access_token <- decode.field("access_token", decode.string)
    decode.success(AuthResponse(refresh_token:, access_token:))
  }

  case decode.run(json, decoder) {
    Ok(value) -> Ok(value)
    Error(_) -> Error(exceptions.JsonDecodeError)
  }
}

pub fn encode_tokens(
  refresh_token: String,
  access_token: String,
) -> string_tree.StringTree {
  let converter =
    c.object({
      use r <- c.field(
        "refresh_token",
        fn(x: AuthResponse) { Ok(x.refresh_token) },
        c.string(),
      )
      use a <- c.field(
        "access_token",
        fn(x: AuthResponse) { Ok(x.access_token) },
        c.string(),
      )

      c.success(AuthResponse(r, a))
    })

  let body =
    AuthResponse(refresh_token, access_token)
    |> cjson.json_encode(converter)

  json.to_string_tree(body)
}
