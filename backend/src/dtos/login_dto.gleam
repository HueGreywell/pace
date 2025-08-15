import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import utils/exceptions.{type Exception, JsonDecodeError}

pub type Login {
  Login(email: String, password: String)
}

pub fn decode_login(json: Dynamic) -> Result(Login, Exception) {
  let decoder = {
    use email <- decode.field("email", decode.string)
    use password <- decode.field("password", decode.string)
    decode.success(Login(password:, email:))
  }

  case decode.run(json, decoder) {
    Ok(value) -> Ok(value)
    Error(_) -> Error(JsonDecodeError)
  }
}
