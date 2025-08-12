import api/auth/access_token
import api/middleware.{Context}
import api/router
import birl
import config/env.{load_config}
import gleam/erlang/process
import infra/database/migratons/migrations
import mist
import shork
import wisp/wisp_mist

pub fn main() {
  token_test()
  let config = load_config()
  let db =
    shork.default_config()
    |> shork.user(config.db_user)
    |> shork.password(config.db_password)
    |> shork.host(config.db_host)
    |> shork.database(config.db)
    |> shork.connect

  migrations.run(db)

  let context = Context(db: db, secret_key: config.secret_key)

  let handler = router.handle_request(_, context)

  let assert Ok(_) =
    handler
    |> wisp_mist.handler(config.secret_key)
    |> mist.new()
    |> mist.port(8000)
    |> mist.start()

  process.sleep_forever()
}

fn wait_two_seconds() {
  process.sleep(2000)
}

fn second_from_now() -> Int {
  birl.to_unix(birl.now()) + 1
}

fn generate_token() -> String {
  access_token.create_access_token_raw(
    secret_key: "secret_key",
    id: "12",
    expiration: second_from_now(),
  )
}

pub fn token_test() {
  let token = generate_token()
  wait_two_seconds()
  let is_valid = access_token.verify_access_token(token, "secret_key")
  echo is_valid == False
  echo "first one is expired"

  let token = generate_token()
  let is_valid = access_token.verify_access_token(token, "secret_key")
  echo "Seconds is not expired"
  echo is_valid == True
}
