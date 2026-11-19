extends Node3D

const CITY_SIZE = 10
const BLOCK_SIZE = 18.0
const ROAD_WIDTH = 6.0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	generate_city()
	create_sunlight()

func create_box(pos, size, color):
	var mesh = BoxMesh.new()
	mesh.size = size

	var material = StandardMaterial3D.new()
	material.albedo_color = color
	mesh.material = material

	var instance = MeshInstance3D.new()
	instance.mesh = mesh 
	instance.position = pos
	add_child(instance)

	var body = StaticBody3D.new()
	body.position = pos
	add_child(body)

	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)

func generate_city():
	var total = CITY_SIZE * BLOCK_SIZE

	create_box(Vector3(0, -0.5, 0), Vector3(total, 1, total), Color(0.2, 0.35, 0.2))

	for x in range(CITY_SIZE):
		for z in range(CITY_SIZE):
			var px = (x - CITY_SIZE / 2.0) * BLOCK_SIZE
			var pz = (z - CITY_SIZE /2.0) * BLOCK_SIZE

			create_block(px, pz)

func create_block(x, z):
	create_box(Vector3(x, 0.05, z), Vector3(BLOCK_SIZE - ROAD_WIDTH, 0.1, BLOCK_SIZE - ROAD_WIDTH), Color(0.55, 0.55, 0.55))

	var height = rng.randf_range(8.0, 55)
	var width = rng.randf_range(6.0, 10.0)

	var color = Color(rng.randf_range(0.3, 0.8), rng.randf_range(0.3, 0.8), rng.randf_range(0.3, 0.8))

	create_box(Vector3(x, height / 2.0 + 0.1, z), Vector3(width, height, width), color)

func create_sunlight():
	var sun = DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-45, 30, 0)
	sun.light_energy = 1.5
	add_child(sun)

	var environment = WorldEnvironment.new()
	var env = Environment.new()

	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.55, 0.75, 1.0)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.8, 0.8, 0.9)

	environment.environment = env
	add_child(environment)