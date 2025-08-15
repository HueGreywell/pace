import dtos/auth_dto
import dtos/login_dto
import gleam/http.{Post}
import services/login_service
import utils/context.{type Context}
import utils/exception_response.{respond_with_error}
import wisp.{type Response}

pub fn handler(ctx: Context) {
  case ctx.req.method {
    Post -> login(ctx)
    _ -> wisp.method_not_allowed([Post])
  }
}

pub fn login(ctx: Context) -> Response {
  use json <- wisp.require_json(ctx.req)
  case login_dto.decode_login(json) {
    Error(error) -> respond_with_error(error)
    Ok(login_dto) -> {
      case login_service.login(login_dto, ctx) {
        Error(error) -> respond_with_error(error)
        Ok(auth) -> {
          let json = auth_dto.encode_tokens(auth)
          wisp.ok() |> wisp.json_body(json)
        }
      }
    }
  }
}
