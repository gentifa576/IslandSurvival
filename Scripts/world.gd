extends Node2D
class_name World

@onready var tile_map: AstarPathfinding = $TileMap
@onready var day_timer: Timer = $DayTimer
@onready var night_timer: Timer = $NightTimer
@onready var structure_container: StructureContainer = $StructureContainer
@onready var npc_scene:PackedScene = preload("res://Scenes/npc.tscn")
@onready var player_scene:PackedScene = preload("res://Scenes/player.tscn")
@onready var structure_scene:PackedScene = preload("res://Scenes/structure.tscn")
@onready var cave_image = preload("res://Asset/Image/cave2.png")
@onready var forest_image = preload("res://Asset/Image/forest2.png")

@export var island_size: float = 64
@export var resource_node: int = 1
@export_range(-1,1) var ocean_level_parameter:float = -0.1
@export_range(0,1) var ground_altitude_parameter:float = 0.05
@export_range(0,1) var ocean_altitude_parameter:float = 0.05

var noise = FastNoiseLite.new()
var chunk_size = 64
var tile_size = 32
var generated_chunks = {} 
var player
var WORLD_SIZE = island_size * 2

var cave_texture
var forest_texture
var cave_locations = []
var forest_locations = []



var spawn_location_vector: Vector2
var walkable_tile = []

#naive 2 tile solution for atlas
var ground_tile = Vector2i(0,0)
var water_tile = Vector2i(1,0)

var ground_tiles = [Vector2i(0,0),Vector2i(1,0),Vector2i(2,0)]
var water_tiles = [Vector2i(0,1),Vector2i(1,1),Vector2i(2,1)]


# Called when the node enters the scene tree for the first time.
func _ready():
	cave_texture = ImageTexture.create_from_image(cave_image)
	forest_texture = ImageTexture.create_from_image(forest_image)
	
	day_timer.timeout.connect(day_end)
	night_timer.timeout.connect(night_end)
	day_timer.start()
	
	noise.seed = randi() + 1
#	noise.seed = -1779600403
#	noise.seed = 1340113787
#	noise.seed = 414202871
#	noise.seed = -1038809495
	print(noise.seed)
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.01
	generate_chunk(Vector2i(0,0))
	update_surrounding_chunks(Vector2i(0,0))
	generate_resources()
	spawn_location_vector = spawn_location()
	
	call_deferred("spawn_npcs", 3)
	call_deferred("spawn_player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player && player.components[BaseComponent.Components.MOVE].is_moving:
		update_chunks_around_player()
	pass

func local_to_map_walkable(coord):
	var map_coord = tile_map.local_to_map(coord)
	return map_coord_walkable(map_coord)
		
func map_coord_walkable(map_coord):
	return tile_map.walkable_cell(map_coord)

func local_to_map_coord(coord):
	var map_coord = tile_map.local_to_map(coord)
	return map_coord

func map_to_local(coord):
	var map_coord = tile_map.map_to_local(coord)
	return map_coord

func get_pathfind(start, end):
	var path = tile_map.get_pathfind(start, end)
	return path

func world_to_chunk(pos: Vector2) -> Vector2i:
	return Vector2i(int(pos.x / (tile_size * chunk_size)), int(pos.y / (tile_size * chunk_size)))

func update_pathfinding():
	if tile_map.alg.is_dirty():
		tile_map.alg.update()
	
func update_chunks_around_player():
	var current_chunk = world_to_chunk(player.position)
	update_surrounding_chunks(current_chunk)

func update_surrounding_chunks(current_chunk):
	for x in range(current_chunk.x - 1, current_chunk.x + 2):
		for y in range(current_chunk.y - 1, current_chunk.y + 2):
			var chunk_pos = Vector2i(x, y)
			if not generated_chunks.has(chunk_pos):
				generate_chunk(chunk_pos)
				tile_map.generate_pathfind()
				generated_chunks[chunk_pos] = true
	update_pathfinding()

func generate_chunk(chunk_pos:Vector2i):
	var _offset = chunk_pos * chunk_size * tile_size
	for x in range(chunk_size):
		for y in range(chunk_size):
			var coord = Vector2i(x + chunk_pos.x * chunk_size, y + chunk_pos.y * chunk_size)
			if (coord == Vector2i(54, 30)):
				var debug = coord
			var noise_value = get_island_noise(coord, island_size)
			if noise_value >= ocean_level_parameter:
				var ground_level = noise_value - ocean_level_parameter
				var ground_tile2 = ground_tiles[2]
				for i in range(1,4):
					if ground_level < i * ground_altitude_parameter:
						ground_tile2 = ground_tiles[i-1]
						break
				tile_map.set_cell(0,coord,1,ground_tile2)
				walkable_tile.append(coord)
			else:
				var ocean_level = noise_value + ocean_level_parameter
				var water_tile2 = water_tiles[0]
				for i in range(1,4):
					if ocean_level > i * ocean_altitude_parameter:
						water_tile2 = water_tiles[i-1]
						break
				tile_map.set_cell(0,coord,1,water_tile2)
		pass
		
func generate_resources():
	var rng = RandomNumberGenerator.new()
	rng.seed = noise.seed
	var cave_texture_stack = ImageTexture.create_from_image(cave_image)
	var forest_texture_stack = ImageTexture.create_from_image(forest_image)
	for i in range(0, resource_node):
		var cave_structure = structure_scene.instantiate()
		cave_structure.add_to_group("cave")
		cave_structure.sprite = cave_texture_stack
		var cave_spawn_loc = walkable_tile[rng.randi() % walkable_tile.size()]
		structure_container.add_structure(cave_spawn_loc, cave_structure)
		
		var forest_structure = structure_scene.instantiate()
		forest_structure.add_to_group("forest")
		forest_structure.sprite = forest_texture_stack
		var forest_spawn_loc = walkable_tile[rng.randi() % walkable_tile.size()]
		structure_container.add_structure(forest_spawn_loc, forest_structure)
		pass
	pass

func get_island_noise(coord: Vector2i, island_radius:float) -> float: 
	var dist_x = coord.x - island_radius
	var dist_y = coord.y - island_radius
	var center_distance = sqrt(pow(dist_x,2.0)+pow(dist_y,2.0))
	if center_distance > island_radius * 0.7:
		return -1
	var island_shape:float = max(0., (island_radius - center_distance) / island_radius)
	var noise_value:float = noise.get_noise_2d(coord.x, coord.y)
	return island_shape * noise_value

func spawn_npcs(count:int):
	for i in range(count):
		var gen_spawn_location = spawn_location_vector * tile_size
		generate_npc(gen_spawn_location)

func generate_npc(_pos):
	var npc = npc_scene.instantiate()
	#UPDATE: Currently stacking player + NPCs on spawn for debug, 
	# swap to using position generated
	npc.position = map_to_local(spawn_location_vector) 
	npc.curr_world = self
	add_child(npc)
	
func spawn_player():
	var new_player = player_scene.instantiate()
	new_player.position = map_to_local(spawn_location_vector)
	new_player.curr_world = self
	self.player = new_player
	add_child(new_player)
	
func spawn_location() -> Vector2i:
	var center = Vector2(island_size, island_size)

	for radius in range(0, island_size, 1):
		for angle in range(0, 360, 5):
			var radians = angle * PI / 180.0
			var x = center.x + radius * cos(radians)
			var y = center.y + radius * sin(radians)
			if valid_spawn(x, y):
#				print(x * tile_size, " ", y * tile_size)
				return Vector2i(x, y)
	return center

func valid_spawn(x, y)->bool:
	var tile_data = tile_map.get_cell_tile_data(0, Vector2(x, y))
	if tile_data:
		return tile_data.get_custom_data("walkable")
	return false

func day_end():
#	print("day end")
	night_timer.start()
	tile_map.day_transition_target = Global.Cycle.NIGHT
	pass

func night_end():
#	print("night end")
	day_timer.start()
	tile_map.day_transition_target = Global.Cycle.DAY
	pass
	
func debug_pathfind(from:Vector2, to: Vector2):
	var line: Line2D = $DebugLine
	line.clear_points()
	var destinations = get_pathfind(local_to_map_coord(from), local_to_map_coord(to))
	line.default_color = Color.RED
	line.points = destinations
	print(destinations)




func _on_button_pressed_reload_scene():
	#fast reload, just start scene tree
	get_tree().reload_current_scene()
