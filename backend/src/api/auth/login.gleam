import api/middleware.{type Context}
import domain/login/login.{decode_login}
import infra/database/queries/queries
import shork
import wisp.{type Request, type Response}

pub fn on_login(req: Request, context: Context) {
  // use json <- wisp.require_json(req)
  // let assert Ok(login) = decode_login(json)
  // let query = shork.query(queries.get_user_by_email)
  // let query = shork.parameter(query, shork.text(login.email))
  // let assert Ok(db_response) = shork.execute(query, context.db)
}
