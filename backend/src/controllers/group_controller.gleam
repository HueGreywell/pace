import dtos/request/create_group_dto.{decode_create_group}
import gleam/http.{Post}
import infra/repository/group_repository
import utils/auth_guard
import utils/context.{type Context}
import utils/exception_response.{respond_with_error}
import wisp

pub fn handler(ctx: Context) {
  let auth = auth_guard.auth_guard(ctx)
  case auth {
    Error(error) -> respond_with_error(error)
    Ok(user_id) -> {
      case ctx.req.method {
        Post -> create_group(ctx, user_id)
        _ -> wisp.method_not_allowed([Post])
      }
    }
  }
}

fn create_group(ctx: Context, user_id: String) {
  use json <- wisp.require_json(ctx.req)
  let group = decode_create_group(json)
  case group {
    Error(error) -> respond_with_error(error)
    Ok(group) -> {
      let insert = group_repository.insert_group(group, user_id, ctx.db)
      case insert {
        Ok(_) -> wisp.created()
        Error(error) -> respond_with_error(error)
      }
    }
  }
}
