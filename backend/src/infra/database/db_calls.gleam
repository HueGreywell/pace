import api/exceptions.{type Exception, DatabaseException}
import domain/register/register.{type Register}
import domain/user/user
import gleam/dynamic/decode
import gleam/option.{type Option, None, Some}
import infra/database/queries/queries
import shork.{type Connection}
import youid/uuid

pub fn insert_user(
  payload: Register,
  connection: Connection,
) -> Result(Nil, Exception) {
  let query =
    shork.query(queries.create_user)
    |> shork.parameter(shork.text(uuid.v4_string()))
    |> shork.parameter(shork.text(payload.username))
    |> shork.parameter(shork.text(payload.email))
    |> shork.parameter(shork.text(payload.password))

  let result = shork.execute(query, connection)

  case result {
    Ok(_) -> Ok(Nil)
    Error(_) -> Error(DatabaseException)
  }
}

pub fn get_user_by_username(
  username: String,
  connection: Connection,
) -> Result(Option(user.User), Exception) {
  let query = queries.get_user_by_username
  get_user_by(query, username, connection)
}

pub fn get_user_by_email(
  email: String,
  connection: Connection,
) -> Result(Option(user.User), Exception) {
  let query = queries.get_user_by_email
  get_user_by(query, email, connection)
}

fn get_user_by(
  query: String,
  parameter: String,
  connection: Connection,
) -> Result(Option(user.User), Exception) {
  let query =
    shork.query(query)
    |> shork.parameter(shork.text(parameter))
    |> shork.returning(decode_user())

  let result = shork.execute(query, connection)

  case result {
    Ok(user_rows) -> {
      case user_rows.rows {
        [first, ..] -> Ok(Some(first))
        [] -> Ok(None)
      }
    }
    Error(_) -> Error(DatabaseException)
  }
}

fn decode_user() -> decode.Decoder(user.User) {
  use id <- decode.field(0, decode.string)
  use username <- decode.field(1, decode.string)
  use password <- decode.field(3, decode.string)
  use email <- decode.field(2, decode.string)

  decode.success(user.User(
    id: id,
    username: username,
    password: password,
    email: email,
  ))
}
