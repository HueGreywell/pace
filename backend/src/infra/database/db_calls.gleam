import api/exceptions.{type Exception, DatabaseException}
import domain/register/register.{type Register}
import infra/database/queries/queries
import shork.{type Connection}
import youid/uuid

pub fn insert_user(
  payload: Register,
  connection: Connection,
) -> Result(Nil, Exception) {
  let query = shork.query(queries.create_user)
  let query = shork.parameter(query, shork.text(uuid.v4_string()))
  let query = shork.parameter(query, shork.text(payload.username))
  let query = shork.parameter(query, shork.text(payload.email))
  let query = shork.parameter(query, shork.text(payload.password))

  let result = shork.execute(query, connection)
  case result {
    Ok(_) -> Ok(Nil)
    Error(_) -> Error(DatabaseException)
  }
}
