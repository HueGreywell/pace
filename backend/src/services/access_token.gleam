import birl
import gleam/list
import gleam/string
import gwt
import wisp.{type Request}
import youid/uuid.{v4_string}

pub fn one_hour_from_now() -> Int {
  birl.to_unix(birl.now()) + 3600
}

pub fn create_access_token(secret_key: String, user_id: String) -> String {
  create_access_token_raw(
    secret_key:,
    user_id:,
    expiration: one_hour_from_now(),
  )
}

/// Open for testing use [create_access_token]
pub fn create_access_token_raw(
  secret_key secret_key: String,
  user_id user_id: String,
  expiration expiration: Int,
) -> String {
  let jwt =
    gwt.new()
    |> gwt.set_subject(user_id)
    |> gwt.set_issued_at(birl.to_unix(birl.now()))
    |> gwt.set_expiration(expiration)
    |> gwt.set_jwt_id(v4_string())
    |> gwt.set_issuer("access-token")

  gwt.to_signed_string(jwt, gwt.HS256, secret_key)
}

pub fn get_auth_header(req: Request) -> #(Bool, String) {
  case list.key_find(req.headers, "authorization") {
    Ok(auth) -> {
      // drop "Bearer "
      let token = string.drop_start(auth, 7)
      #(True, token)
    }
    Error(_) -> {
      #(False, "")
    }
  }
}

pub fn verify_access_token(jwt: String, secret_key: String) -> Bool {
  let jwt_with_signature = gwt.from_signed_string(jwt, secret_key)
  case jwt_with_signature {
    Ok(jwt) -> {
      let assert Ok(token_type) = gwt.get_issuer(jwt)
      case token_type {
        "access-token" -> True
        _ -> False
      }
    }
    Error(err) -> {
      echo err
      False
    }
  }
}
