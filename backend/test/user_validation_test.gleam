import api/exceptions.{
  InvalidEmailFormat, PasswordEmpty, PasswordTooShort, UsernameEmpty,
  UsernameTooLong,
}
import domain/utils/user_validation
import gleam/int
import gleam/list
import gleam/string
import gleeunit

pub fn main() {
  gleeunit.main()
}

pub fn check_empty_email_test() {
  let check = user_validation.check_email("")
  assert check == Error(InvalidEmailFormat)
}

pub fn check_wrong_email_format_test() {
  let check = user_validation.check_email("   ")
  assert check == Error(InvalidEmailFormat)

  let check = user_validation.check_email("ahsdfah")
  assert check == Error(InvalidEmailFormat)

  let check = user_validation.check_email("test@")
  assert check == Error(InvalidEmailFormat)

  let check = user_validation.check_email("test@test")
  assert check == Error(InvalidEmailFormat)

  let check = user_validation.check_email("test@test.com ")
  assert check == Error(InvalidEmailFormat)

  let check = user_validation.check_email(" test@test.com ")
  assert check == Error(InvalidEmailFormat)

  let check = user_validation.check_email("test@test.com")
  assert check == Ok("test@test.com")
}

pub fn check_empty_username_test() {
  let check = user_validation.check_username("")
  assert check == Error(UsernameEmpty)
}

pub fn check_username_test() {
  let long_username = generate_long_text()
  let check = user_validation.check_username(long_username)
  assert check == Error(UsernameTooLong)
}

pub fn check_empty_password_test() {
  let check = user_validation.check_password("")
  assert check == Error(PasswordEmpty)
}

pub fn check_password_too_short_test() {
  let check = user_validation.check_password("1")
  assert check == Error(PasswordTooShort)
}

fn generate_long_text() -> String {
  let numbers = list.range(1, 100)
  let lines = list.map(numbers, fn(n) { int.to_string(n) })
  string.join(lines, "\n")
}
