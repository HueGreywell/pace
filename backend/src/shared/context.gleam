import shork.{type Connection}
import wisp.{type Request}

pub type Context {
  Context(req: Request, db: Connection, secret_key: String)
}
