extends SceneTree

func _init():
	var file = FileAccess.open("data.txt", FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var mapres = parse_map(content)
	var grid = mapres.grid
	var start_pos = mapres.start
	var end_pos = mapres.end

	print("Grid size: ", grid.size(), "x", grid[0].size())
	print("Start: ", start_pos, " End: ", end_pos)

	var distance = bfs_distances_to_end(grid, end_pos)
	print("dist", distance)

	walk_from_start(grid, start_pos, distance)
	walk_from_start2(grid, start_pos, distance)
	quit()

func parse_map(input: String) -> Dictionary:
	var lines = input.strip_edges().split("\n")
	var grid = []
	var start_pos = Vector2()
	var end_pos = Vector2()

	for y in range(lines.size()):
		var row = []
		for x in range(lines[y].length()):
			var char = lines[y][x]

			if char == 'S':
				start_pos = Vector2(x, y)
				row.append(false)  
			elif char == 'E':
				end_pos = Vector2(x, y)
				row.append(false) 
			elif char == '#':
				row.append(true) 
			else:  # '.'
				row.append(false)

		grid.append(row)

	return {
		"grid": grid,
		"start": start_pos,
		"end": end_pos
	}

func bfs_distances_to_end(grid: Array, end: Vector2) -> Array:
	var distances = []
	var height = grid.size()
	var width = grid[0].size()

	# Initialize distance matrix with -1 (unvisited)
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(-1)
		distances.append(row)

	var queue = [end]
	distances[end.y][end.x] = 0

	var directions = [Vector2(0,1), Vector2(1,0), Vector2(0,-1), Vector2(-1,0)]

	while queue.size() > 0:
		var pos = queue.pop_front()

		for dir in directions:
			var new_pos = pos + dir
			var nx = int(new_pos.x)
			var ny = int(new_pos.y)

			if nx >= 0 and ny >= 0 and ny < height and nx < width:
				if not grid[ny][nx] and distances[ny][nx] == -1:  
					distances[ny][nx] = distances[pos.y][pos.x] + 1
					queue.append(new_pos)

	return distances

func walk_from_start(grid: Array, start: Vector2, distances_to_end: Array):
	var visited = []
	var height = grid.size()
	var width = grid[0].size()

	var total = 0

	# Initialize visited matrix with false
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(false)
		visited.append(row)

	var queue = [start]
	visited[start.y][start.x] = true

	var directions = [Vector2(0,1), Vector2(1,0), Vector2(0,-1), Vector2(-1,0)]

	while queue.size() > 0:
		var pos = queue.pop_front()
		#print(pos)
		total += count_cheats(grid, distances_to_end, pos)

		for dir in directions:
			var new_pos = pos + dir
			var nx = int(new_pos.x)
			var ny = int(new_pos.y)

			if nx >= 0 and ny >= 0 and ny < height and nx < width:
				if not grid[ny][nx] and not visited[ny][nx]:  
					visited[ny][nx] = true
					queue.append(new_pos)
	print("[p1] total cheats: ", total)

func count_cheats(grid: Array, distances_to_end: Array, start: Vector2) -> int:
	var count = 0
	var height = grid.size()
	var width = grid[0].size()
	var directions = [Vector2(0,1), Vector2(1,0), Vector2(0,-1), Vector2(-1,0)]

	var original_distance = distances_to_end[start.y][start.x]

	var goal = 100

	for dir1 in directions:
		var pos1 = start + dir1
		if pos1.x >= 0 and pos1.y >= 0 and pos1.y < height and pos1.x < width:
			if grid[int(pos1.y)][int(pos1.x)]: # no point of cheating if there is no wall here
				for dir2 in directions:
					var pos2 = pos1 + dir2
					if pos2.x >= 0 and pos2.y >= 0 and pos2.y < height and pos2.x < width:
						if not grid[int(pos2.y)][int(pos2.x)]:
							var new_distance = 2 + distances_to_end[int(pos2.y)][int(pos2.x)]
							var saved = original_distance - new_distance
							if saved >= goal:
								count += 1

	return count

# bruh, I thought you could walk through 2 walls...
# 3041 too high (tried not cheatwalking to non-wall)
# 3723 is too high....
# 3663 also too high when tried svaed >= 101...

func walk_from_start2(grid: Array, start: Vector2, distances_to_end: Array):
	var visited = []
	var height = grid.size()
	var width = grid[0].size()

	var total = 0

	for y in range(height):
		var row = []
		for x in range(width):
			row.append(false)
		visited.append(row)

	var queue = [start]
	visited[start.y][start.x] = true

	var directions = [Vector2(0,1), Vector2(1,0), Vector2(0,-1), Vector2(-1,0)]

	while queue.size() > 0:
		var pos = queue.pop_front()
		total += count_cheats2(grid, distances_to_end, pos)
		for dir in directions:
			var new_pos = pos + dir
			var nx = int(new_pos.x)
			var ny = int(new_pos.y)
			if nx >= 0 and ny >= 0 and ny < height and nx < width:
				if not grid[ny][nx] and not visited[ny][nx]:  
					visited[ny][nx] = true
					queue.append(new_pos)
	print("[p2] total cheats: ", total)

# part2 was pretty easy actually, because it's a grid
func count_cheats2(grid: Array, distances_to_end: Array, start: Vector2) -> int:
	var height = grid.size()
	var width = grid[0].size()
	var directions = [Vector2(0,1), Vector2(1,0), Vector2(0,-1), Vector2(-1,0)]

	var original_distance = distances_to_end[start.y][start.x]

	var goal = 100
	var max_steps = 20

	var valid_end_positions = {}

	# BFS queue: [position, steps_taken]
	var queue = [[start, 0]]
	var visited = {}
	visited[str(start)] = true

	while queue.size() > 0:
		var current = queue.pop_front()
		var pos = current[0]
		var steps = current[1]

		if steps >= max_steps:
			continue

		for dir in directions:
			var new_pos = pos + dir
			var nx = int(new_pos.x)
			var ny = int(new_pos.y)

			# Check bounds
			if nx >= 0 and ny >= 0 and ny < height and nx < width:
				var pos_key = str(new_pos)

				# Skip if already visited at a shorter or equal path
				if visited.has(pos_key):
					continue

				visited[pos_key] = true
				var new_steps = steps + 1

				# If this is a non-wall position, check if it saves enough time
				if not grid[ny][nx] and distances_to_end[ny][nx] != -1:
					var new_distance = new_steps + distances_to_end[ny][nx]
					var saved = original_distance - new_distance
					if saved >= goal:
						valid_end_positions[pos_key] = true

				# Continue BFS if we haven't reached max steps
				if new_steps < max_steps:
					queue.append([new_pos, new_steps])

	return valid_end_positions.size()
