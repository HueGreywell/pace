import dtos/register_dto
import gleam/http.{Post}
import services/register_service
import utils/context.{type Context}
import utils/exception_response.{respond_with_error}
import wisp

pub fn handler(ctx: Context) {
  case ctx.req.method {
    Post -> register(ctx)
    _ -> wisp.method_not_allowed([Post])
  }
}

fn register(ctx: Context) {
  use json <- wisp.require_json(ctx.req)
  case register_dto.decode_register(json) {
    Error(error) -> respond_with_error(error)
    Ok(register_dto) -> {
      case register_service.register(register_dto, ctx) {
        Ok(_) -> wisp.created()
        Error(error) -> respond_with_error(error)
      }
    }
  }
}
