import gleam/io

pub fn main() {
  io.print("hello from cli")
}

fn load_application_secret() -> String {
  os.get_env("SECRET_KEY")
  |> result.unwrap("SECRET_KEY is not set.")
}


pub fn get_env_var(name: String) -> Option(String) {
  erlang.call("os", "getenv", [erlang.atom(name)])
  |> case {
    erlang.NIL -> None
    value -> 
      Some(erlang.binary_to_string(value))
  }
