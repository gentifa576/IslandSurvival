extends Node2D

var noise = FastNoiseLite.new()
var chunk_size = 64
var tile_size = 32
var generated_chunks = {} 
@onready var player:CharacterBody2D = get_node("Player")
@onready var npc_scene = preload("res://Scenes/npc.tscn")
@onready var tile_map:TileMap = get_node("TileMap")
@export var island_size:float = 40
var WORLD_SIZE = island_size * 2

#naive 2 tile solution for atlas
var ground_tile = Vector2i(0,0)
var water_tile = Vector2i(1,0)

#naive optimization to not check chunk per frame
@onready var player_move:MovementComponent = player.get_node("ComponentContainer/MovementComponent")


func _ready():
	noise.seed = randi() + 1
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.02
	generate_chunk(Vector2i(0,0))
	player.position = spawn_location() * tile_size 
	spawn_npcs(5)
	update_chunks_around_player()



func _process(delta):
	if player_move.is_moving:
		update_chunks_around_player()
		
	
func world_to_chunk(pos: Vector2) -> Vector2i:
	return Vector2i(int(pos.x / (tile_size * chunk_size)), int(pos.y / (tile_size * chunk_size)))

# Generate chunks around the player
func update_chunks_around_player():
	var current_chunk = world_to_chunk(player.position)
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
			var world_x = offset.x + x * tile_size
			var world_y = offset.y + y * tile_size
			var noise_value = get_island_noise(x,y,island_size)
			var coord = Vector2i(x + chunk_pos.x * chunk_size, y + chunk_pos.y * chunk_size)
			
			
			if noise_value > 0:
				tile_map.set_cell(0,coord,2,ground_tile)
			else:
				tile_map.set_cell(0,coord,2,water_tile)
		pass
		

func get_island_noise(x:float,y:float,island_radius:float) -> float: 
	var dist_x = x - island_radius
	var dist_y = y - island_radius
	var center_distance = sqrt(pow(dist_x,2.0)+pow(dist_y,2.0))
	if center_distance > island_radius * 0.8:
		return -1
	var island_shape:float = max(0., (island_radius - center_distance) / island_radius)
	var noise_value:float = noise.get_noise_2d(x,y)
	return island_shape * noise_value

func spawn_npcs(count:int):
	for i in range(count):
		var spawn_location = spawn_location() * tile_size
		generate_npc(spawn_location)

func generate_npc(pos:Vector2):
	var npc = npc_scene.instantiate()
	npc.position = position
	self.add_child(npc)
	
	
func spawn_location()->Vector2:
	var center = Vector2(island_size, island_size)
	var search_radius = 20
	
	for radius in range(0,island_size,1):
		for angle in range(0,360,5):
			var radians = angle * PI / 180.0
			var x = center.x + radius * cos(radians)
			var y = center.y + radius * sin(radians)
			if valid_spawn(x,y):
				return Vector2(x,y)
	return center

func valid_spawn(x,y)->bool:
	var tile_type = tile_map.get_cell_atlas_coords(0,Vector2i(x*tile_size,y*tile_size))
	print(tile_type + "tile")
	if tile_type == ground_tile:
		print(x,y)
		return true
	return false

