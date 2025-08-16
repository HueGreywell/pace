import birl
import dtos/auth_dto
import gleam/int
import gleam/option
import gwt
import infra/repository/refresh_token_repository
import infra/repository/user_repository
import models/user.{type User}
import services/access_token
import utils/context.{type Context}
import utils/exceptions.{type Exception}

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
    refresh_token_repository.insert_refresh_token(
      jwt_with_signature,
      user_id,
      ctx.db,
    )

  case db_response {
    Ok(_) -> Ok(jwt_with_signature)
    Error(value) -> Error(value)
  }
}

pub fn get_user_from_refresh_token(
  jwt_string: String,
  ctx: Context,
) -> Result(User, Exception) {
  let user_id = get_user_id(jwt_string, ctx.secret_key)
  case user_id {
    Error(_) -> Error(exceptions.NotAuthenticated)
    Ok(user_id) -> {
      let user = user_repository.get_user_by_id(user_id, ctx.db)
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
  refresh_token_repository.get_refresh_token(user_id, ctx.db)
}

pub fn generate_tokens(
  user: user.User,
  ctx: Context,
) -> Result(auth_dto.AuthDTO, exceptions.Exception) {
  let access_token = access_token.create_access_token(ctx.secret_key, user.id)
  let refresh_token = create_refresh_token(user.id, ctx)
  case refresh_token {
    Error(error) -> Error(error)
    Ok(refresh_token) -> Ok(auth_dto.AuthDTO(refresh_token, access_token))
  }
}
