pub const get_users = "
  SELECT
    id, username, password, email
  FROM
    users"

pub const get_user = "
  SELECT
    id, username, password, email
  FROM
    users
  WHERE
    id = ?"

pub const get_user_by_username = "
  SELECT
    id, username, password, email
  FROM
    users
  WHERE
    username = ?"

pub const get_user_by_email = "
  SELECT
    id, username, password, email
  FROM
    users
  WHERE
    email = ?"

pub const create_user = "
  INSERT INTO users
    (id, username, email, password)
  VALUES
    (?, ?, ?, ?)"

pub const create_refresh_token = "
  INSERT INTO refresh_tokens
    (user_id, token)
  VALUES
    ($1, $2)
  RETURNING
    id, user_id::text, token"

pub const get_refresh_token_by_user_id = "
  SELECT 
    id, user_id::text, token
  FROM
    refresh_tokens
  WHERE
    user_id = $1"
