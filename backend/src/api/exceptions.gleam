import gleam/json

pub type Exception {
  DatabaseException
  GenericError
  UsernameEmpty
  UsernameTooLong
  PasswordTooShort
  JsonDecodeError
  InvalidEmailFormat
}

pub fn exception_response(exception: Exception) -> json.Json {
  let generic_err =
    ExceptionMsg(message: "Something went wrong", code: "GENERIC_ERROR")

  let exception_msg = case exception {
    DatabaseException -> generic_err
    GenericError -> generic_err
    InvalidEmailFormat ->
      ExceptionMsg(message: "Invalid email format", code: "INVALID_EMAIL")
    JsonDecodeError ->
      ExceptionMsg(message: "Invalid json", code: "INVALID_JSON")
    PasswordTooShort ->
      ExceptionMsg(message: "Password too short", code: "PASSWOR_TOO_SHORT")
    UsernameTooLong ->
      ExceptionMsg(
        message: "Username too long max chars is 30",
        code: "USERNAME_TOO_LONG",
      )
    UsernameEmpty ->
      ExceptionMsg(message: "Username is empty", code: "EMPTY_USERNAME")
  }

  encode_exception_msg(exception_msg)
}

pub type ExceptionMsg {
  ExceptionMsg(message: String, code: String)
}

pub fn encode_exception_msg(exception: ExceptionMsg) -> json.Json {
  json.object([
    #("message", json.string(exception.message)),
    #("code", json.string(exception.code)),
  ])
}
