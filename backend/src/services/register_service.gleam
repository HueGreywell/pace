import dtos/register_dto.{type Register}
import gleam/option.{type Option, None, Some}
import gleam/regexp
import gleam/string
import infra/repository/user_repository
import shork
import utils/context.{type Context}
import utils/exceptions.{
  type Exception, InvalidEmailFormat, PasswordEmpty, PasswordTooShort,
  UsernameEmpty, UsernameTooLong,
}

pub fn register(register: Register, ctx: Context) {
  case validate(register) {
    Error(error) -> Error(error)
    Ok(_) -> {
      case does_user_exist(register.username, register.email, ctx.db) {
        Some(error) -> Error(error)
        None ->
          case user_repository.insert_user(register, ctx.db) {
            Error(error) -> Error(error)
            Ok(value) -> Ok(value)
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
            Error(value) -> Error(value)
            Ok(_) -> Ok(Nil)
          }
        }
      }
    }
  }
}

fn check_email(email: String) -> Result(String, Exception) {
  case regexp.from_string("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$") {
    Ok(email_regex) ->
      case regexp.check(email_regex, email) {
        True -> Ok(email)
        False -> Error(InvalidEmailFormat)
      }

    Error(_) -> Error(InvalidEmailFormat)
  }
}

fn check_password(password: String) -> Result(String, Exception) {
  let length = string.length(password)
  case length {
    0 -> Error(PasswordEmpty)
    length if length <= 8 -> Error(PasswordTooShort)
    _ -> Ok(password)
  }
}

fn check_username(username: String) -> Result(String, Exception) {
  let length = string.length(username)
  case length {
    length if length >= 30 -> Error(UsernameTooLong)
    0 -> Error(UsernameEmpty)
    _ -> Ok(username)
  }
}

fn does_user_exist(
  username: String,
  email: String,
  connection: shork.Connection,
) -> Option(Exception) {
  let user = user_repository.get_user_by_email(email, connection)
  case user {
    Ok(None) -> {
      let user = user_repository.get_user_by_username(username, connection)
      case user {
        Ok(Some(_)) -> Some(exceptions.UserWithUsernameExists)
        Error(value) -> Some(value)
        Ok(None) -> None
      }
    }
    Ok(Some(_)) -> Some(exceptions.UserWithEmailExists)
    Error(value) -> Some(value)
  }
}
