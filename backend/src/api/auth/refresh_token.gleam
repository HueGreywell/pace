import api/exceptions.{type Exception}
import api/middleware.{type Context}
import birl
import domain/user/user
import gleam/int
import gleam/option
import gwt
import infra/database/db_calls

pub fn create_refresh_token(
  user_id: String,
  ctx: Context,
) -> Result(String, Exception) {
  let one_month = birl.to_unix(birl.now()) + 2_628_288
  let jti = int.random(1000)
  let jwt =
    gwt.new()
    |> gwt.set_subject(user_id)
    |> gwt.set_issued_at(birl.to_unix(birl.now()))
    |> gwt.set_expiration(one_month)
    |> gwt.set_jwt_id(int.to_string(jti))
    |> gwt.set_issuer("refresh-token")

  let jwt_with_signature = gwt.to_signed_string(jwt, gwt.HS256, ctx.secret_key)

  let db_response =
    db_calls.insert_refresh_token(jwt_with_signature, user_id, ctx.db)

  case db_response {
    Ok(_) -> Ok(jwt_with_signature)
    Error(value) -> Error(value)
  }
}

pub fn get_user_from_refresh_token(
  jwt_string: String,
  ctx: Context,
) -> Result(user.User, Exception) {
  let user_id = get_user_id(jwt_string, ctx.secret_key)
  case user_id {
    Error(_) -> Error(exceptions.NotAuthenticated)
    Ok(user_id) -> {
      let user = db_calls.get_user_by_id(user_id, ctx.db)
      case user {
        Ok(option.Some(user)) -> Ok(user)
        _ -> Error(exceptions.NotAuthenticated)
      }
    }
  }
}

fn get_user_id(jwt_string: String, secret_key: String) {
  let decoded = gwt.from_signed_string(jwt_string, secret_key)
  case decoded {
    Error(_) -> Error(exceptions.NotAuthenticated)
    Ok(jwt) -> {
      let subject = gwt.get_subject(jwt)
      case subject {
        Error(_) -> Error(exceptions.NotAuthenticated)
        Ok(user_id) -> {
          let issuer = gwt.get_issuer(jwt)
          case issuer {
            Error(_) -> Error(exceptions.NotAuthenticated)
            Ok("refresh-token") -> Ok(user_id)
            _ -> Error(exceptions.NotAuthenticated)
          }
        }
      }
    }
  }
}

pub fn get_refresh_token(
  ctx: Context,
  user_id: String,
) -> Result(String, Exception) {
  db_calls.get_refresh_token(user_id, ctx.db)
}
