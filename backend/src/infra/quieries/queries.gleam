pub const get_user = "
  SELECT
    id, username, password, email
  FROM
    users
  WHERE
    id = ?"

pub const get_user_by_id = "
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
