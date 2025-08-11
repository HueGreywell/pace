import api/exceptions.{
  type Exception, InvalidEmailFormat, PasswordEmpty, PasswordTooShort,
  UsernameEmpty, UsernameTooLong,
}
import gleam/option.{type Option, None, Some}
import gleam/regexp
import gleam/string
import infra/database/db_calls
import shork

pub fn check_username(username: String) -> Result(String, Exception) {
  let length = string.length(username)
  case length {
    length if length >= 30 -> Error(UsernameTooLong)
    0 -> Error(UsernameEmpty)
    _ -> Ok(username)
  }
}

pub fn check_password(password: String) -> Result(String, Exception) {
  let length = string.length(password)
  case length {
    0 -> Error(PasswordEmpty)
    length if length <= 8 -> Error(PasswordTooShort)
    _ -> Ok(password)
  }
}

pub fn check_email(email: String) -> Result(String, Exception) {
  case regexp.from_string("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$") {
    Ok(email_regex) ->
      case regexp.check(email_regex, email) {
        True -> Ok(email)
        False -> Error(InvalidEmailFormat)
      }

    Error(_) -> Error(InvalidEmailFormat)
  }
}

pub fn does_user_exist(
  username: String,
  email: String,
  connection: shork.Connection,
) -> Option(Exception) {
  let user = db_calls.get_user_by_email(email, connection)
  case user {
    Ok(None) -> {
      let user = db_calls.get_user_by_username(username, connection)
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
