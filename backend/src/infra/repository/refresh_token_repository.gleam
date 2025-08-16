import gleam/dynamic/decode
import infra/quieries/queries
import shork.{type Connection}
import utils/exceptions.{type Exception, DatabaseException}
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
