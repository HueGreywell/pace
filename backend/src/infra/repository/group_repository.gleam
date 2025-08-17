import dtos/request/create_group_dto
import infra/quieries/queries
import shork.{type Connection}
import utils/exceptions.{type Exception, DatabaseException}
import youid/uuid

pub fn insert_group(
  payload: create_group_dto.CreateGroupDTO,
  user_id: String,
  connection: Connection,
) -> Result(Nil, Exception) {
  let query =
    shork.query(queries.create_running_group)
    |> shork.parameter(shork.text(uuid.v4_string()))
    |> shork.parameter(shork.text(payload.name))
    |> shork.parameter(shork.text(user_id))

  let result = shork.execute(query, connection)

  case result {
    Ok(_) -> Ok(Nil)
    Error(error) -> {
      echo error
      Error(DatabaseException)
    }
  }
}
