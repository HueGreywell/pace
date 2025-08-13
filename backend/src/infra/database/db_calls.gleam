import api/exceptions.{type Exception, DatabaseException}
import domain/register/register.{type Register}
import domain/user/user
import domain/utils/password_utils
import gleam/dynamic/decode
import gleam/option.{type Option, None, Some}
import infra/database/queries/queries
import shork.{type Connection}
import youid/uuid

pub fn get_refresh_token(
  user_id: String,
  connection: Connection,
) -> Result(String, Exception) {
  let query =
    shork.query(queries.get_refresh_token_by_user_id)
    |> shork.parameter(shork.text(user_id))
    |> shork.returning(decode_refresh_row())

  let result = shork.execute(query, connection)

  case result {
    Error(_) -> Error(exceptions.NotAuthenticated)
    Ok(value) -> {
      case value.rows {
        [] -> Error(exceptions.NotAuthenticated)
        [first, ..] -> Ok(first)
      }
    }
  }
}

fn decode_refresh_row() -> decode.Decoder(String) {
  use refresh_token <- decode.field(2, decode.string)
  decode.success(refresh_token)
}

pub fn insert_refresh_token(
  refresh_token: String,
  user_id: String,
  connection: Connection,
) -> Result(Nil, Exception) {
  let query =
    shork.query(queries.create_refresh_token)
    |> shork.parameter(shork.text(uuid.v4_string()))
    |> shork.parameter(shork.text(user_id))
    |> shork.parameter(shork.text(refresh_token))

  let result = shork.execute(query, connection)

  case result {
    Ok(_) -> Ok(Nil)
    Error(error) -> {
      echo error
      Error(DatabaseException)
    }
  }
}

pub fn insert_user(
  payload: Register,
  connection: Connection,
) -> Result(Nil, Exception) {
  let hashed_password = password_utils.hash_password(payload.password)
  let query =
    shork.query(queries.create_user)
    |> shork.parameter(shork.text(uuid.v4_string()))
    |> shork.parameter(shork.text(payload.username))
    |> shork.parameter(shork.text(payload.email))
    |> shork.parameter(shork.text(hashed_password))

  let result = shork.execute(query, connection)

  case result {
    Ok(_) -> Ok(Nil)
    Error(_) -> Error(DatabaseException)
  }
}

pub fn get_user_by_id(
  username: String,
  connection: Connection,
) -> Result(Option(user.User), Exception) {
  let query = queries.get_user_by_id
  get_user_by(query, username, connection)
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
  use password <- decode.field(2, decode.string)
  use email <- decode.field(3, decode.string)

  decode.success(user.User(
    id: id,
    username: username,
    password: password,
    email: email,
  ))
}
