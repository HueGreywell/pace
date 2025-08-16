import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import utils/exceptions.{type Exception}

pub type Register {
  Register(email: String, password: String, username: String)
}

pub fn decode_register(json: Dynamic) -> Result(Register, Exception) {
  let decoder = {
    use email <- decode.field("email", decode.string)
    use password <- decode.field("password", decode.string)
    use username <- decode.field("username", decode.string)
    decode.success(Register(password:, email:, username:))
  }

  case decode.run(json, decoder) {
    Ok(value) -> Ok(value)
    Error(_) -> Error(exceptions.JsonDecodeError)
  }
}
