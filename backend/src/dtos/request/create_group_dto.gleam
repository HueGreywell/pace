import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import utils/exceptions.{type Exception, JsonDecodeError}

pub type CreateGroupDTO {
  CreateGroupDTO(name: String)
}

pub fn decode_create_group(json: Dynamic) -> Result(CreateGroupDTO, Exception) {
  let decoder = {
    use name <- decode.field("name", decode.string)
    decode.success(CreateGroupDTO(name))
  }

  case decode.run(json, decoder) {
    Ok(value) -> Ok(value)
    Error(_) -> Error(JsonDecodeError)
  }
}
