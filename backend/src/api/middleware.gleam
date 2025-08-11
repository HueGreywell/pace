import api/exceptions.{type Exception}
import gleam/json
import shork.{type Connection}
import wisp

/// A Context type, which holds any additional data that the request handlers
/// need in addition to the request.
pub type Context {
  Context(db: Connection, secret_key: String)
}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  handle_request(req)
}

pub fn respond_with_exception(code: Int, exception: Exception) {
  let error_msg = exceptions.exception_response(exception)
  wisp.response(code)
  |> wisp.string_body(json.to_string(error_msg))
}
