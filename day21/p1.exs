keypad = %{{0,0} => 7, {0,1} => 8, {0,2} => 9,
           {1,0} => 4, {1,1} => 5, {1,2} => 6,
           {2,0} => 1, {2,1} => 2, {2,2} => 3,
                       {3,1} => 0, {3,2} => :A,
          }
keypad_start = {3,2}
keypad_inverse = Map.new(keypad, fn {k, v} -> {v, k} end)

directional = %{             {0,1} => :^, {0,2} => :A,
                {1,0} => :<, {1,1} => :v, {1,2} => :>,
               }
directional_start = {0,2}
directional_inverse = Map.new(directional, fn {k, v} -> {v, k} end)

defmodule Day21 do
  def find_paths(map, at, find, visited) do
    if Map.has_key?(map, at) do
      if MapSet.member?(visited, at) do # already been here...
        nil
      else
        # get it
        button = map[at]
        if button == find do
          # we found the path to it.
          [[]]
        else
          # look further, get new 4 new positions, give them recursively, filter out nils, and flatten it
          [{1,0, :v},{-1,0, :^},{0,1, :>},{0,-1, :<}]
          |> Enum.map(&(
            [elem(&1, 2), find_paths(map, {elem(at,0)+elem(&1, 0), elem(at,1)+elem(&1, 1)}, find, MapSet.put(visited, at))]
          ))
          |> Enum.filter(fn [_, a] -> a != nil end)
          |> Enum.flat_map(fn [way_sym, paths] ->
              paths |> Enum.map(fn x -> [way_sym | x] end)
          end)
        end
      end
    else
      # outside bounds
      nil
    end
  end
  # returns list of (list of presses) with the same length, that cause the code to be outputted on the map
  def get_minimum_presses(map, map_inverse, start, code) do
    if length(code) == 0 do 
      # nothing to press 
      [[]]
    else 
      paths = Day21.find_paths(map, start, hd(code), MapSet.new())
      min_len = paths |> Enum.map(&length/1) |> Enum.min
      best_paths = paths |> Enum.filter(&(length(&1) == min_len))
      # on all of these, press 'A'
      paths_after = Day21.get_minimum_presses(map,  map_inverse, map_inverse[hd(code)], tl(code))
      for p <- best_paths, a <- paths_after, do: p ++ [:A] ++ a
    end
  end 

  def do_for_code(code, keypad, keypad_inverse, keypad_start, directional, directional_start, directional_inverse, n_directional) do
    # Start with keypad
    paths = Day21.get_minimum_presses(keypad, keypad_inverse, keypad_start, code)

    # Apply directional keypads n_directional times
    final_paths = 1..n_directional
    |> Enum.reduce(paths, fn _, current_paths ->
      next_paths = (for code <- current_paths, do: Day21.get_minimum_presses(directional, directional_inverse, directional_start, code)) |> Enum.flat_map(&(&1))
      min_len = next_paths |> Enum.map(&length/1) |> Enum.min
      x = next_paths |> Enum.filter(&(length(&1) == min_len))
      IO.puts(length(x))
      x
    end)

    length(hd(final_paths))
  end

  def solve_all_codes(keypad, keypad_inverse, keypad_start, directional, directional_start, directional_inverse, n_directional \\ 2) do
    codes_and_numbers = [
      {[7, 8, 9, :A], 789},
      {[5, 4, 0, :A], 540},
      {[2, 8, 5, :A], 285},
      {[1, 4, 0, :A], 140},
      {[1, 8, 9, :A], 189}
    ]

    result = codes_and_numbers
    |> Enum.map(fn {code, number} ->
      length = do_for_code(code, keypad, keypad_inverse, keypad_start, directional, directional_start, directional_inverse, n_directional)
      length * number
    end)
    |> Enum.sum()

    IO.inspect("my result:")
    IO.inspect(result)
  end

end

Day21.solve_all_codes(keypad, keypad_inverse, keypad_start, directional, directional_start, directional_inverse)
