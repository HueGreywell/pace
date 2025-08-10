///
/// THIS FILE IS FORMATED BY HAND 
///
import gleam/json

pub type Exception {
  DatabaseException
  GenericError
  UsernameEmpty
  UsernameTooLong
  PasswordTooShort
  PasswordEmpty
  JsonDecodeError
  InvalidEmailFormat
}

pub fn exception_response(exception: Exception) -> json.Json {
  let #(message, code) = exception_to_details(exception)

  json.object([
    #("message", json.string(message)),
    #("code", json.string(code)),
  ])
}

pub fn exception_to_details(exception: Exception) -> #(String, String) {
  case exception {
    InvalidEmailFormat -> #(
      "Invalid email format",
      "INVALID_EMAIL"
    )
    JsonDecodeError -> #(
      "Invalid json",
      "INVALID_JSON"
    )
    UsernameEmpty -> #(
      "Username is empty",
      "EMPTY_USERNAME"
    )
    DatabaseException | GenericError -> #(
      "Something went wrong",
      "GENERIC_ERROR",
    )
    PasswordTooShort -> #(
      "Password is too short min length is 8",
      "PASSWORD_TOO_SHORT",
    )
    PasswordEmpty -> #(
      "Password is empty",
      "PASSWORD_IS_EMPTY"
    )
    UsernameTooLong -> #(
      "Username is too long max chars is 30",
      "USERNAME_TOO_LONG",
    )
  }
}
