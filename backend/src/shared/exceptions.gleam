import gleam/json

pub type Exception {
  NotAuthenticated
  DatabaseException
  GenericError
  UsernameEmpty
  UsernameTooLong
  PasswordTooShort
  PasswordEmpty
  JsonDecodeError
  InvalidEmailFormat
  UserWithEmailExists
  UserWithUsernameExists
}

// pub fn exception_response(exception: Exception) -> json.Json {
//   let #(message, code) = exception_to_details(exception)
//
//   json.object([
//     #("message", json.string(message)),
//     #("code", json.string(code)),
//   ])
// }

pub type ExceptionResponse {
  ExceptionResponse(http_code: Int, message: String, code: Int)
}
// pub fn exception_to_details(exception: Exception) -> #(String, String) {
//   case exception {
//     InvalidEmailFormat ->
//       ExceeptionResponse(400, "Invalid email format", "INVALID_EMAIL")
//     JsonDecodeError -> #(400, "Invalid json", "INVALID_JSON")
//     UsernameEmpty -> #(400, "Username is empty", "EMPTY_USERNAME")
//     DatabaseException | GenericError -> #(
//       500,
//       "Something went wrong",
//       "GENERIC_ERROR",
//     )
//     PasswordTooShort -> #(
//       400,
//       "Password is too short min length is 8",
//       "SHORT_PASSWORD",
//     )
//     PasswordEmpty -> #(400, "Password is empty", "EMPTY_PASSWORD")
//     UsernameTooLong -> #(
//       400,
//       "Username is too long max chars is 30",
//       "LONG_USERNAME",
//     )
//     UserWithEmailExists -> #(
//       409,
//       "User with this email exist",
//       "USER_EMAIL_EXIST",
//     )
//     UserWithUsernameExists -> #(
//       409,
//       "User with this username exist",
//       "USER_USERNAME_EXIST",
//     )
//     NotAuthenticated -> #(401, "Not authenticated", "NOT_AUTHENTICATED")
//     //
//   }
// }
