import gleam/http.{Post}
import shared/context.{type Context}
import wisp.{type Response}

pub fn handler(ctx: Context) {
  case ctx.req.method {
    Post -> login(ctx)
    _ -> wisp.method_not_allowed([Post])
  }
}

pub fn login(ctx: Context) -> Response {
  todo
}
