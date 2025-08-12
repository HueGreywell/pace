import api/middleware.{type Context, respond_with_exception}
import domain/login/login.{decode_login}
import wisp.{type Request}

pub fn on_login(req: Request, context: Context) {
  use json <- wisp.require_json(req)
  case decode_login(json) {
    Error(error) -> respond_with_exception(400, error)
    Ok(login) -> {
      let user = login.get_user(login, context.db)
      case user {
        Ok(_) -> wisp.ok()
        Error(error) -> respond_with_exception(400, error)
      }
    }
  }
}
