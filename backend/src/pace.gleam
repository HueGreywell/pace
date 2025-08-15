import config/env.{load_config}
import gleam/erlang/process
import infra/migrations/migrations
import mist
import router
import shork
import wisp/wisp_mist

pub fn main() {
  let config = load_config()
  let connection =
    shork.default_config()
    |> shork.user(config.db_user)
    |> shork.password(config.db_password)
    |> shork.host(config.db_host)
    |> shork.database(config.db)
    |> shork.connect

  migrations.run(connection)

  let handler = router.handle_request(_, connection, config.secret_key)

  let assert Ok(_) =
    handler
    |> wisp_mist.handler(config.secret_key)
    |> mist.new()
    |> mist.port(8000)
    |> mist.start()

  process.sleep_forever()
}
