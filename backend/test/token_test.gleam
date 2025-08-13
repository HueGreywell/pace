import api/auth/access_token
import birl
import gleam/erlang/process

fn wait_two_seconds() {
  process.sleep(2000)
}

fn second_from_now() -> Int {
  birl.to_unix(birl.now()) + 1
}

fn generate_token() -> String {
  access_token.create_access_token_raw(
    secret_key: "secret_key",
    user_id: "12",
    expiration: second_from_now(),
  )
}

pub fn token_test() {
  let token = generate_token()
  wait_two_seconds()
  let is_valid = access_token.verify_access_token(token, "secret_key")
  assert is_valid == False

  let token = generate_token()
  let is_valid = access_token.verify_access_token(token, "secret_key")
  assert is_valid == True
}
