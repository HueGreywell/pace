import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode

pub type Login {
  Login(email: String, password: String)
}

pub fn decode_login(json: Dynamic) -> Result(Login, List(decode.DecodeError)) {
  let decoder = {
    use email <- decode.field("email", decode.string)
    use password <- decode.field("password", decode.string)
    decode.success(Login(password:, email:))
  }

  decode.run(json, decoder)
}
