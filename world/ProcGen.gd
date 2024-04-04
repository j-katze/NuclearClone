extends TileMap

enum TILES{
		Floor,
		Wall
}

@export var map_size = Vector2(70, 70)
@export var percentage_to_fill = 0.35
@onready var player = $Player
var spawn_chance = 0.007
var total_walkers = []

class walker extends Object:
	var pos

	func _init(starting_position):
		pos = starting_position

func _ready():
	var cells = []
	randomize()
	for x in range(-10, map_size.x + 10):
		for y in range(-10, map_size.y + 10):
			cells.append(Vector2i(x, y))
	set_cells_terrain_connect(3, cells, 0, 2, false)
	set_cells_terrain_connect(2, cells, 0, 1, false)
	set_cells_terrain_connect(1, cells, 0, 0, false)
	set_cells_terrain_connect(0, cells, 1, 0, false)
	move_walkers()

func move_walkers():
	var i = 0
	var pos = Vector2(map_size.x/2, map_size.y/2)
	var w = walker.new(pos)
	var last_pos
	total_walkers.append(w)
	while i < 10000:
		for walk in total_walkers:
			var num = randi()%4
			match num:
				0:
					walk.pos += Vector2(1, 0)
				1:
					walk.pos += Vector2(0, 1)
				2:
					walk.pos += Vector2(-1, 0)
				3:
					walk.pos += Vector2(0, -1)
			walk.pos.x = clamp(walk.pos.x, 0, map_size.x)
			walk.pos.y = clamp(walk.pos.y, 0, map_size.y)
			var cells = []
			cells.append(Vector2i(walk.pos.x, walk.pos.y))
			if get_cell_atlas_coords(1, Vector2i(walk.pos.x, walk.pos.y)) != Vector2i(-1, -1):
				set_cells_terrain_path(1, cells, 0, -1, false)
				set_cells_terrain_path(2, cells, 0, -1, false)
				set_cells_terrain_path(3, cells, 0, -1, false)
				last_pos = walk.pos
			if randf() < spawn_chance and total_walkers.size() < 10:
				var y = walker.new(walk.pos)
				total_walkers.append(y)
			if randf() < spawn_chance / 2 and total_walkers.size() > 1:
				total_walkers.erase(walk)
		i += 1
		#await get_tree().process_frame
		var filled_percent = count_floors()  / (map_size.x * map_size.y)
		print(int((filled_percent / percentage_to_fill)*100), "%")
		if filled_percent >= percentage_to_fill:
			break
	player.global_position = (last_pos * 16) + Vector2(1, 1)
	player.show()
	player.set_physics_process(true)

func count_floors():
	var floor_count = 0
	for x in map_size.x:
		for y in map_size.y:
			if get_cell_atlas_coords(1, Vector2i(x, y)) == Vector2i(-1, -1):
				floor_count += 1
	return floor_count
