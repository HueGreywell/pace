import antigone
import gleam/bit_array

pub fn hash_password(password: String) -> String {
  let bit_arr = bit_array.from_string(password)
  antigone.hasher()
  |> antigone.time_cost(3)
  |> antigone.memory_cost(16)
  |> antigone.hash(bit_arr)
}

pub fn is_same_password(password: String, hashed_password: String) -> Bool {
  let bit_arr = bit_array.from_string(password)
  antigone.verify(bit_arr, hashed_password)
}
