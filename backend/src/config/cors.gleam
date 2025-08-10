import cors_builder as cors
import gleam/http

pub fn setup_cors() {
  cors.new()
  |> cors.allow_origin("*")
  |> cors.allow_all_origins()
  |> cors.allow_method(http.Get)
  |> cors.allow_method(http.Options)
  |> cors.allow_method(http.Post)
  |> cors.allow_header("Content-Type")
  |> cors.allow_header("Origin")
  |> cors.allow_header("Authorization")
}
//https://github.com/donnaloia/authentication-service/blob/main/src/auth_server.gleam
