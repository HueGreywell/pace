import api/exceptions.{
  type Exception, InvalidEmailFormat, PasswordEmpty, PasswordTooShort,
  UsernameEmpty, UsernameTooLong,
}

import gleam/regexp
import gleam/string

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
    length if length <= 8 -> Error(PasswordTooShort)
    0 -> Error(PasswordEmpty)
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
