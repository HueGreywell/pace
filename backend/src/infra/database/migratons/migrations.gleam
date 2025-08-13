import shork.{type Connection}

pub fn run(conn: Connection) {
  let run_mig = run_migration(_, conn)
  case run_mig(setup_users_table) {
    Error(_) -> echo "error"
    Ok(_) -> echo "migration suceed"
  }

  case run_mig(setup_refresh_tokens_table) {
    Error(_) -> echo "error"
    Ok(_) -> echo "migration suceed"
  }
}

fn run_migration(
  migration: String,
  conn: Connection,
) -> Result(shork.Returned(Nil), shork.QueryError) {
  let query = shork.query(migration)
  shork.execute(query, conn)
}

const setup_users_table = "
CREATE TABLE IF NOT EXISTS users (
    id uuid PRIMARY KEY,
    username VARCHAR(255),
    password VARCHAR(255),
    email VARCHAR(255)
)"

const setup_refresh_tokens_table = "CREATE TABLE IF NOT EXISTS refresh_tokens (
  id uuid PRIMARY KEY,
  user_id uuid,
  token VARCHAR(255),
  FOREIGN KEY (user_id) REFERENCES users(id)
  )"
