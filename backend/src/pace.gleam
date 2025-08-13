import api/middleware.{Context}
import api/router
import config/env.{load_config}
import gleam/erlang/process
import infra/database/migratons/migrations
import mist
import shork
import wisp/wisp_mist

pub fn main() {
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
