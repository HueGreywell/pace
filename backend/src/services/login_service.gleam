import dtos/login_dto
import gleam/option.{None, Some}
import infra/repository/user_repository
import services/refresh_token
import utils/context
import utils/exceptions
import utils/password_hash

pub fn login(dto: login_dto.Login, ctx: context.Context) {
  let user = user_repository.get_user_by_email(dto.email, ctx.db)
  case user {
    Error(value) -> Error(value)
    Ok(None) -> Error(exceptions.GenericError)
    Ok(Some(user)) -> {
      let correct_login =
        password_hash.is_same_password(dto.password, user.password)

      case correct_login {
        False -> Error(exceptions.GenericError)
        True -> refresh_token.generate_tokens(user, ctx)
      }
    }
  }
}
