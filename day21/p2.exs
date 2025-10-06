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

defmodule PathFinder do
  def create_path_map(grid, grid_inverse) do
    keys = Map.keys(grid_inverse)

    for from <- keys, to <- keys, into: %{} do
      paths = find_all_minimal_paths(grid, grid_inverse, from, to)
      {{from, to}, paths}
    end
  end

  defp find_all_minimal_paths(grid, grid_inverse, from, to) do
    if from == to do
      [[:A]]
    else
      from_pos = grid_inverse[from]
      to_pos = grid_inverse[to]

      # BFS to find all shortest paths
      queue = [{from_pos, []}]
      visited = %{from_pos => 0}
      min_distance = nil
      all_paths = []

      bfs(queue, visited, to_pos, grid, min_distance, all_paths, 0)
      |> Enum.map(fn path -> path ++ [:A] end)
    end
  end

  defp bfs([], _visited, _target, _grid, _min_distance, all_paths, _current_dist) do
    all_paths
  end

  defp bfs([{pos, path} | rest], visited, target, grid, min_distance, all_paths, current_dist) do
    if pos == target do
      new_min_distance = length(path)
      cond do
        min_distance == nil or new_min_distance < min_distance ->
          bfs(rest, visited, target, grid, new_min_distance, [path], current_dist)
        new_min_distance == min_distance ->
          bfs(rest, visited, target, grid, min_distance, [path | all_paths], current_dist)
        true ->
          bfs(rest, visited, target, grid, min_distance, all_paths, current_dist)
      end
    else
      path_length = length(path)
      if min_distance != nil and path_length >= min_distance do
        bfs(rest, visited, target, grid, min_distance, all_paths, current_dist)
      else
        neighbors = get_neighbors(pos, grid)
        new_queue_items = for {new_pos, direction} <- neighbors,
                              not Map.has_key?(visited, new_pos) or visited[new_pos] >= path_length + 1 do
          {new_pos, path ++ [direction]}
        end

        new_visited = Enum.reduce(new_queue_items, visited, fn {new_pos, new_path}, acc ->
          Map.put(acc, new_pos, length(new_path))
        end)

        new_queue = rest ++ new_queue_items
        bfs(new_queue, new_visited, target, grid, min_distance, all_paths, current_dist)
      end
    end
  end

  defp get_neighbors({row, col}, grid) do
    [{row-1, col, :^}, {row+1, col, :v}, {row, col-1, :<}, {row, col+1, :>}]
    |> Enum.filter(fn {r, c, _dir} -> Map.has_key?(grid, {r, c}) end)
    |> Enum.map(fn {r, c, dir} -> {{r, c}, dir} end)
  end
end

keypad_paths = PathFinder.create_path_map(keypad, keypad_inverse)
directional_paths = PathFinder.create_path_map(directional, directional_inverse)


defmodule DistanceCalculator do
  @keypad_distances Map.new(keypad_paths, fn {{from, to}, paths} ->
    distance = if from == to, do: 1, else: length(hd(paths))
    {{from, to}, distance}
  end)

  @directional_distances Map.new(directional_paths, fn {{from, to}, paths} ->
    distance = if from == to, do: 1, else: length(hd(paths))
    {{from, to}, distance}
  end)

  @keypad_num_ways Map.new(keypad_paths, fn {{from, to}, paths} ->
    {{from, to}, length(paths)}
  end)

  @directional_num_ways Map.new(directional_paths, fn {{from, to}, paths} ->
    {{from, to}, length(paths)}
  end)

  def keypad_dist(from, to) do
    @keypad_distances[{from, to}]
  end

  def directional_dist(from, to) do
    @directional_distances[{from, to}]
  end

  def keypad_num_ways(from, to) do
    @keypad_num_ways[{from, to}]
  end

  def directional_num_ways(from, to) do
    @directional_num_ways[{from, to}]
  end

  def total_distance(sequence, map_type) do
    dist_func = case map_type do
      :keypad -> &keypad_dist/2
      :directional -> &directional_dist/2
    end

    # Make sure sequence is a list
    sequence_list = if is_list(sequence), do: sequence, else: [sequence]

    [:A | sequence_list]
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [from, to] -> dist_func.(from, to) end)
    |> Enum.sum()
  end
end
defmodule MetaPathFilter do
  def filter_minimal_meta_paths(path_map, target_map_type) do
    Map.new(path_map, fn {{from, to}, paths} ->
      paths_with_meta_length = Enum.map(paths, fn path ->
        meta_length = DistanceCalculator.total_distance(path, target_map_type)
        {path, meta_length}
      end)

      min_meta_length = paths_with_meta_length
                       |> Enum.map(fn {_path, meta_length} -> meta_length end)
                       |> Enum.min()

      minimal_paths = paths_with_meta_length
                     |> Enum.filter(fn {_path, meta_length} -> meta_length == min_meta_length end)
                     |> Enum.map(fn {path, _meta_length} -> path end)

      {{from, to}, minimal_paths}
    end)
  end
end

keypad_meta_paths = MetaPathFilter.filter_minimal_meta_paths(keypad_paths, :directional)
directional_meta_paths = MetaPathFilter.filter_minimal_meta_paths(directional_paths, :directional)

defmodule CodeParser do
  def parse_code(code) do
    String.graphemes(code) |> Enum.map(fn
      "0" -> 0
      "1" -> 1
      "2" -> 2
      "3" -> 3
      "4" -> 4
      "5" -> 5
      "6" -> 6
      "7" -> 7
      "8" -> 8
      "9" -> 9
      "A" -> :A
    end)
  end

  def code_to_pairs(code) do
    code_list = parse_code(code)
    [:A | code_list]
    |> Enum.chunk_every(2, 1, :discard)
  end
end

defmodule MemoizedDistance do
  def start_memo() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def stop_memo() do
    Agent.stop(__MODULE__)
  end

  def longdist(from, to, depth, directional_paths) do
    key = {from, to, depth}

    case Agent.get(__MODULE__, &Map.get(&1, key)) do
      nil ->
        result = compute_longdist(from, to, depth, directional_paths)
        Agent.update(__MODULE__, &Map.put(&1, key, result))
        result
      cached_result ->
        cached_result
    end
  end

  defp compute_longdist(from, to, depth, directional_paths) do
    cond do
      depth == 24 ->
        # Base case: use ground truth distance
        DistanceCalculator.directional_dist(from, to)

      depth < 24 ->
        # Recursive case: get paths and compute minimum cost
        paths = directional_paths[{from, to}]

        if paths == nil or length(paths) == 0 do
          # Fallback to direct distance if no paths found
          DistanceCalculator.directional_dist(from, to)
        else
          paths
          |> Enum.map(&compute_path_cost(&1, depth, directional_paths))
          |> Enum.min()
        end

      true ->
        # Invalid depth
        raise "Invalid depth: #{depth}. Depth must be 0-3."
    end
  end

  defp compute_path_cost(path, depth, directional_paths) do
    [:A | path]
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [from, to] -> longdist(from, to, depth + 1, directional_paths) end)
    |> Enum.sum()
  end

  def process_code(code, depth, keypad_paths, directional_paths) do
    # First, convert the code to keypad pairs
    keypad_pairs = CodeParser.code_to_pairs(code)

    total_cost = keypad_pairs
    |> Enum.map(fn [from, to] ->
      paths = keypad_paths[{from, to}]

      if paths == nil or length(paths) == 0 do
        DistanceCalculator.keypad_dist(from, to)
      else
        paths
        |> Enum.map(fn path ->
          [:A | path]
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.map(fn [dir_from, dir_to] ->
            longdist(dir_from, dir_to, depth, directional_paths)
          end)
          |> Enum.sum()
        end)
        |> Enum.min()
      end
    end)
    |> Enum.sum()

    total_cost
  end

  def solve_advent_problem(codes, depth, keypad_paths, directional_paths) do
    codes
    |> Enum.map(fn code ->
      # Extract numeric part (remove 'A')
      numeric_value = code
      |> String.replace("A", "")
      |> String.to_integer()

      cost = process_code(code, depth, keypad_paths, directional_paths)

      result = numeric_value * cost
      IO.puts("#{code}: cost=#{cost}, numeric=#{numeric_value}, result=#{result}")
      result
    end)
    |> Enum.sum()
  end
end
# Test the parser
IO.inspect(CodeParser.parse_code("029A"))
IO.inspect(CodeParser.code_to_pairs("029A"))

# Test distance functions
IO.inspect(DistanceCalculator.keypad_dist(:A, 7))
IO.inspect(DistanceCalculator.directional_dist(:^, :v))

MemoizedDistance.start_memo()

IO.puts("Testing longdist at depth 3 (base case):")
IO.inspect(MemoizedDistance.longdist(:A, :>, 3, directional_paths))
IO.inspect(DistanceCalculator.directional_dist(:A, :>))

IO.puts("Testing longdist at depth 2 (recursive case):")
IO.inspect(MemoizedDistance.longdist(:A, :>, 2, directional_paths))

IO.puts("Testing longdist at depth 1:")
IO.inspect(MemoizedDistance.longdist(:A, :>, 1, directional_paths))

MemoizedDistance.stop_memo()

MemoizedDistance.start_memo()

codes = ["789A", "540A", "285A", "140A", "189A"]

IO.puts("\nSolving Advent of Code problem at depth 0:")
final_answer = MemoizedDistance.solve_advent_problem(codes, 0, keypad_paths, directional_paths)
IO.puts("\nFinal Answer: #{final_answer}")

MemoizedDistance.stop_memo()







