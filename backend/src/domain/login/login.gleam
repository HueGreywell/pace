import api/exceptions.{type Exception, JsonDecodeError}
import domain/user/user.{type User}
import domain/utils/password_utils
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option, None, Some}
import infra/database/db_calls
import shork.{type Connection}

pub type Login {
  Login(email: String, password: String)
}

pub fn decode_login(json: Dynamic) -> Result(Login, Exception) {
  let decoder = {
    use email <- decode.field("email", decode.string)
    use password <- decode.field("password", decode.string)
    decode.success(Login(password:, email:))
  }

  case decode.run(json, decoder) {
    Ok(value) -> Ok(value)
    Error(_) -> Error(JsonDecodeError)
  }
}

pub fn get_user(login: Login, connection: Connection) -> Result(User, Exception) {
  let user = db_calls.get_user_by_email(login.email, connection)
  case user {
    Error(value) -> Error(value)
    Ok(None) -> Error(exceptions.GenericError)
    Ok(Some(user)) -> {
      let correct_login =
        password_utils.is_same_password(login.password, user.password)

      case correct_login {
        True -> Ok(user)
        False -> Error(exceptions.GenericError)
      }
    }
  }
}
