import antigone
import dtos/auth_dto
import dtos/login_dto
import gleam/bit_array
import gleam/option.{None, Some}
import infra/repository/user_repository
import models/user
import utils/context.{type Context}
import utils/exceptions

pub fn login(dto: login_dto.Login, ctx: context.Context) {
  let user = user_repository.get_user_by_email(dto.email, ctx.db)
  case user {
    Error(value) -> Error(value)
    Ok(None) -> Error(exceptions.GenericError)
    Ok(Some(user)) -> {
      let correct_login = is_same_password(dto.password, user.password)

      case correct_login {
        False -> Error(exceptions.GenericError)
        True -> {
          generate_tokens(user, ctx)
        }
      }
    }
  }
}

fn is_same_password(password: String, hashed_password: String) -> Bool {
  let bit_arr = bit_array.from_string(password)
  antigone.verify(bit_arr, hashed_password)
}

pub fn generate_tokens(
  user: user.User,
  ctx: Context,
) -> Result(auth_dto.AuthDTO, exceptions.Exception) {
  let access_token = "test"
  //access_token.create_access_token(ctx.secret_key, user.id)
  let refresh_token = Ok("test")
  //refresh_token.create_refresh_token(user.id, ctx)
  case refresh_token {
    Error(error) -> Error(error)
    Ok(refresh_token) -> Ok(auth_dto.AuthDTO(refresh_token, access_token))
  }
}
