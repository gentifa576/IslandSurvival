extends AstarPathfinding

var noise = FastNoiseLite.new()
var chunk_size = 64
var tile_size = 32
var generated_chunks = {} 
var player
@onready var npc_scene = preload("res://Scenes/npc.tscn")
@onready var player_scene = preload("res://Scenes/player.tscn")
@onready var tile_map:TileMap = self
@export var island_size:float = 64
var WORLD_SIZE = island_size * 2

var spawn_location_vector: Vector2

@export var parent_node: Node2D

#naive 2 tile solution for atlas
var ground_tile = Vector2i(0,0)
var water_tile = Vector2i(1,0)

#naive optimization to not check chunk per frame
#@onready var player_move:MovementComponent = player.get_node("ComponentContainer/MovementComponent")


func _ready():
	noise.seed = randi() + 1
# Seed with no land
#	noise.seed = -1779600403
	print(noise.seed)
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.01
	generate_chunk(Vector2i(0,0))
	update_surrounding_chunks(Vector2i(0,0))
#	update_chunks_around_player()
	spawn_location_vector = spawn_location()
	super._ready()
	call_deferred("spawn_npcs", 5)
	call_deferred("spawn_player")

#func set_spawn_location(object):
#	object.position = spawn_location_vector * tile_size

func _process(delta):
	if player && player.components[BaseComponent.Components.MOVE].is_moving:
		update_chunks_around_player()
	pass
	
func world_to_chunk(pos: Vector2) -> Vector2i:
	return Vector2i(int(pos.x / (tile_size * chunk_size)), int(pos.y / (tile_size * chunk_size)))

# Generate chunks around the player
func update_chunks_around_player():
	var current_chunk = world_to_chunk(player.position)
	update_surrounding_chunks(current_chunk)

func update_surrounding_chunks(current_chunk):
	for x in range(current_chunk.x - 1, current_chunk.x + 2):
		for y in range(current_chunk.y - 1, current_chunk.y + 2):
			var chunk_pos = Vector2i(x, y)
			if not generated_chunks.has(chunk_pos):
				generate_chunk(chunk_pos)
				generated_chunks[chunk_pos] = true

func generate_chunk(chunk_pos:Vector2i):
	var offset = chunk_pos * chunk_size * tile_size
	for x in range(chunk_size):
		for y in range(chunk_size):
			var coord = Vector2i(x + chunk_pos.x * chunk_size, y + chunk_pos.y * chunk_size)
			var noise_value = get_island_noise(coord, island_size)
#			print(noise_value)
			if noise_value > 0:
				tile_map.set_cell(0,coord,2,ground_tile)
			else:
				tile_map.set_cell(0,coord,2,water_tile)
		pass
		

func get_island_noise(coord: Vector2i, island_radius:float) -> float: 
	var dist_x = coord.x - island_radius
	var dist_y = coord.y - island_radius
	var center_distance = sqrt(pow(dist_x,2.0)+pow(dist_y,2.0))
	if center_distance > island_radius * 0.9:
		return -1
	var island_shape:float = max(0., (island_radius - center_distance) / island_radius)
	var noise_value:float = noise.get_noise_2d(coord.x, coord.y)
	return island_shape * noise_value

func spawn_npcs(count:int):
	for i in range(count):
		var spawn_location = spawn_location_vector * tile_size
		generate_npc(spawn_location)

func generate_npc(pos:Vector2):
	var npc = npc_scene.instantiate()
	npc.position = spawn_location_vector * tile_size
	#need to specify curr_world - this is current an exported var in the NPC
	#need to pass curr_world at runtime, use parent node
	npc.curr_world = get_parent()
	parent_node.add_child(npc)
	
func spawn_player():
	var player = player_scene.instantiate()
	player.position = spawn_location_vector * tile_size
	player.curr_world = get_parent()
	self.player = player
	parent_node.add_child(player)
	
func spawn_location()->Vector2:
	var center = Vector2(island_size, island_size)
	
	for radius in range(0,island_size,1):
		for angle in range(0,360,5):
			var radians = angle * PI / 180.0
			var x = center.x + radius * cos(radians)
			var y = center.y + radius * sin(radians)
			if valid_spawn(x, y):
				print(x * tile_size, " ", y * tile_size)
				return Vector2(x,y)
	return center

func valid_spawn(x,y)->bool:
	var tile_data = tile_map.get_cell_tile_data(0, Vector2(x, y))
	if tile_data:
		return tile_data.get_custom_data("walkable")
	return false

