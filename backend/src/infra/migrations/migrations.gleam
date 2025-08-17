import shork.{type Connection}

pub fn run(conn: Connection) {
  let run_mig = run_migration(_, conn)
  case run_mig(setup_users_table) {
    Error(_) -> echo "error migrating users"
    Ok(_) -> echo "users -> migration suceed"
  }

  case run_mig(setup_refresh_tokens_table) {
    Error(_) -> echo "error migrating refresh tokens"
    Ok(_) -> echo "refresh_tokens -> migration suceed"
  }

  case run_mig(setup_running_group) {
    Error(error) -> {
      echo error
      echo "err"
    }
    Ok(_) -> echo "running_group -> migration suceed"
  }

  case run_mig(setup_running_group_members) {
    Error(_) -> echo "error migrating running groups"
    Ok(_) -> echo "running_group -> migration suceed"
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

const setup_running_group = "CREATE TABLE IF NOT EXISTS running_group (
  id UUID PRIMARY KEY,
  name VARCHAR(255),
  owner_id UUID,
  FOREIGN KEY (owner_id) REFERENCES users(id)
);"

const setup_running_group_members = "CREATE TABLE IF NOT EXISTS running_group_members (
  id UUID PRIMARY KEY,
  group_id UUID,
  user_id UUID,
  FOREIGN KEY (group_id) REFERENCES running_group(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);"
