import gleam/json
import utils/exceptions as e
import wisp.{type Response}

pub type ExceptionResponse {
  ExceptionResponse(http_code: Int, message: String, code: String)
}

pub fn respond_with_error(exception: e.Exception) -> Response {
  let exception_response = exception_to_details(exception)
  let body =
    json.object([
      #("message", json.string(exception_response.message)),
      #("code", json.string(exception_response.code)),
    ])

  let json_body = json.to_string_tree(body)

  wisp.json_response(json_body, exception_response.http_code)
}

pub fn exception_to_details(exception: e.Exception) -> ExceptionResponse {
  case exception {
    e.InvalidEmailFormat ->
      ExceptionResponse(400, "Invalid email format", "INVALID_EMAIL")
    e.JsonDecodeError -> ExceptionResponse(400, "Invalid json", "INVALID_JSON")
    e.UsernameEmpty ->
      ExceptionResponse(400, "Username is empty", "EMPTY_USERNAME")
    e.DatabaseException | e.GenericError ->
      ExceptionResponse(500, "Something went wrong", "GENERIC_ERROR")
    e.PasswordTooShort ->
      ExceptionResponse(
        400,
        "Password is too short min length is 8",
        "SHORT_PASSWORD",
      )
    e.PasswordEmpty ->
      ExceptionResponse(400, "Password is empty", "EMPTY_PASSWORD")
    e.UsernameTooLong ->
      ExceptionResponse(
        400,
        "Username is too long max chars is 30",
        "LONG_USERNAME",
      )
    e.UserWithEmailExists ->
      ExceptionResponse(409, "User with this email exist", "USER_EMAIL_EXIST")
    e.UserWithUsernameExists ->
      ExceptionResponse(
        409,
        "User with this username exist",
        "USER_USERNAME_EXIST",
      )
    e.NotAuthenticated ->
      ExceptionResponse(401, "Not authenticated", "NOT_AUTHENTICATED")
  }
}
