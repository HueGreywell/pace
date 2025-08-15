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
