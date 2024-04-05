extends TileMap

enum TILES{
		Floor,
		Wall
}

@export var map_size = Vector2(70, 70)
@export var amount_to_fill = 1000
@onready var player = $Player
@onready var frorg = preload("res://enemies/Frorg.tscn")
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
	var pos = Vector2i(map_size.x/2, map_size.y/2)
	var w = walker.new(pos)
	var last_pos
	var cells = []
	total_walkers.append(w)
	while i < 10000:
		for walk in total_walkers:
			var num = randi()%4
			match num:
				0:
					walk.pos += Vector2i(1, 0)
				1:
					walk.pos += Vector2i(0, 1)
				2:
					walk.pos += Vector2i(-1, 0)
				3:
					walk.pos += Vector2i(0, -1)
			walk.pos.x = clamp(walk.pos.x, 0, map_size.x)
			walk.pos.y = clamp(walk.pos.y, 0, map_size.y)
			if !cells.has(Vector2i(walk.pos.x, walk.pos.y)):
				cells.append(Vector2i(walk.pos.x, walk.pos.y))
				if cells.has(Vector2i(walk.pos.x, walk.pos.y)):
					last_pos = walk.pos
			if randi()%100 < 40:
				if !cells.has(Vector2i(walk.pos.x+1, walk.pos.y)):
					cells.append(Vector2i(walk.pos.x+1, walk.pos.y))
				if !cells.has(Vector2i(walk.pos.x, walk.pos.y+1)):
					cells.append(Vector2i(walk.pos.x, walk.pos.y+1))
				if !cells.has(Vector2i(walk.pos.x+1, walk.pos.y+1)):
					cells.append(Vector2i(walk.pos.x+1, walk.pos.y+1))
			if randf() < spawn_chance and total_walkers.size() < 10:
				var y = walker.new(walk.pos)
				total_walkers.append(y)
			if randf() < spawn_chance / 2 and total_walkers.size() > 1:
				total_walkers.erase(walk)
		i += 1
		#await get_tree().process_frame
		#var filled_percent = float(cells.size()  / amount_to_fill)
		print(int((float(cells.size())/amount_to_fill)*100), "%")
		if cells.size() > amount_to_fill:
			break
	set_cells_terrain_connect(1, cells, 0, -1, false)
	set_cells_terrain_connect(2, cells, 0, -1, false)
	set_cells_terrain_connect(3, cells, 0, -1, false)
	player.global_position = (last_pos * 16) + Vector2i(8, 8)
	player.show()
	player.set_physics_process(true)
	spawn_enemies(cells)

func spawn_enemies(cells):
	var enemy_instance = []
	for tile in cells:
		var tile_global_position := Vector2(tile.x * 16, tile.y * 16)
		if randi()%1000<15 && enemy_instance.size() <= 100 && tile_global_position.distance_to(player.global_position) > 5*16:
			enemy_instance.append(frorg.instantiate())
			add_child(enemy_instance.back())
			enemy_instance.back().global_position = (tile * 16) + Vector2i(8, 8)
