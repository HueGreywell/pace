import api/auth/login
import api/auth/register
import api/middleware.{type Context, middleware}
import config/cors as apps_cors
import cors_builder as cors
import gleam/json
import gleam/string_tree
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- middleware(req)
  use req <- cors.wisp_middleware(req, apps_cors.setup_cors())

  case wisp.path_segments(req) {
    //["users"] -> users.get_users_view(req, ctx)
    //["users", uuid] -> users.get_user_view(req, ctx, uuid)
    ["login"] -> login.on_login(req, ctx)
    ["register"] -> register.on_register(req, ctx)
    //["logout"] -> logout.logout_view(req, ctx)
    //["refresh-token"] -> refresh_token.refresh_token_view(req, ctx)
    ["test"] -> tes()
    _ -> wisp.not_found()
  }
}

fn tes() -> Response {
  // Build a JSON object
  let body_json = json.object([#("message", json.string("Hello from /test!"))])

  // Convert the JSON object to a String
  let body_string = json.to_string(body_json)

  let res = string_tree.from_string(body_string)

  // Return the JSON response with HTTP status 200
  wisp.json_response(res, 200)
}
