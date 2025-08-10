import api/exceptions.{type Exception}
import api/middleware.{type Context}
import domain/register/register.{type Register, decode_register}
import domain/utils/user_validation.{check_email, check_password, check_username}
import gleam/json
import infra/database/db_calls
import wisp.{type Request, type Response}

pub fn on_register(req: Request, context: Context) -> Response {
  use json <- wisp.require_json(req)

  case decode_register(json) {
    Error(value) -> respond(400, value)
    Ok(register) -> {
      case validate(register) {
        Error(value) -> respond(400, value)
        Ok(_) -> {
          case db_calls.insert_user(register, context.db) {
            Error(_) -> wisp.response(400)
            _ -> wisp.response(200)
          }
        }
      }
    }
  }
}

fn validate(register: Register) -> Result(Nil, Exception) {
  case check_email(register.email) {
    Error(value) -> Error(value)
    Ok(_) -> {
      case check_password(register.password) {
        Error(value) -> Error(value)
        Ok(_) -> {
          case check_username(register.username) {
            Ok(_) -> Ok(Nil)
            Error(value) -> Error(value)
          }
        }
      }
    }
  }
}

fn respond(code: Int, exception: Exception) {
  let error_msg = exceptions.exception_response(exception)
  wisp.response(code)
  |> wisp.string_body(json.to_string(error_msg))
}
