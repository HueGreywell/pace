import dot_env as dot
import dot_env/env

pub type Config {
  Config(
    secret_key: String,
    db_user: String,
    db_password: String,
    db_host: String,
    db: String,
  )
}

pub fn load_config() {
  dot.new()
  |> dot.set_path(".env")
  |> dot.load

  let secret_key = load_secret_key()
  let db_user = load_db_user()
  let db_password = load_db_password()
  let db_host = load_db_host()
  let db = load_db()

  Config(secret_key:, db_user:, db_password:, db_host:, db:)
}

fn load_secret_key() -> String {
  case env.get_string("SECRET_KEY") {
    Ok(value) -> value
    Error(_) -> panic as "Env Error while reading secret key"
  }
}

fn load_db_user() -> String {
  case env.get_string("DB_USER") {
    Ok(value) -> value
    Error(_) -> panic as "Env Error while reading db user"
  }
}

fn load_db_password() -> String {
  case env.get_string("DB_PASSWORD") {
    Ok(value) -> value
    Error(_) -> panic as "Env Error while reading db password"
  }
}

fn load_db_host() -> String {
  case env.get_string("DB_HOST") {
    Ok(value) -> value
    Error(_) -> panic as "Env Error while reading db host"
  }
}

fn load_db() -> String {
  case env.get_string("DB") {
    Ok(value) -> value
    Error(_) -> panic as "Env Error while reading db host"
  }
}
