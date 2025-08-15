import convert as c
import convert/json as cjson
import gleam/dynamic
import gleam/dynamic/decode
import gleam/json
import gleam/string_tree
import utils/exceptions.{type Exception}

pub type AuthDTO {
  AuthDTO(refresh_token: String, access_token: String)
}

pub fn decode_tokens(json: dynamic.Dynamic) -> Result(AuthDTO, Exception) {
  let decoder = {
    use refresh_token <- decode.field("refresh_token", decode.string)
    use access_token <- decode.field("access_token", decode.string)
    decode.success(AuthDTO(refresh_token:, access_token:))
  }

  case decode.run(json, decoder) {
    Ok(value) -> Ok(value)
    Error(_) -> Error(exceptions.JsonDecodeError)
  }
}

pub fn encode_tokens(dto: AuthDTO) -> string_tree.StringTree {
  let converter =
    c.object({
      use r <- c.field(
        "refresh_token",
        fn(x: AuthDTO) { Ok(x.refresh_token) },
        c.string(),
      )
      use a <- c.field(
        "access_token",
        fn(x: AuthDTO) { Ok(x.access_token) },
        c.string(),
      )

      c.success(AuthDTO(r, a))
    })

  let body =
    dto
    |> cjson.json_encode(converter)

  json.to_string_tree(body)
}
