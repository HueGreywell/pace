import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode

pub type User {
  User(username: String, password: String, email: String)
}

pub fn decode_user(json: Dynamic) -> Result(User, List(decode.DecodeError)) {
  let decoder = {
    use username <- decode.field("username", decode.string)
    use password <- decode.field("password", decode.string)
    use email <- decode.field("email", decode.string)
    decode.success(User(username:, password:, email:))
  }

  decode.run(json, decoder)
}
