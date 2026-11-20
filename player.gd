extends CharacterBody3D

const WALK_SPEED = 6.0
const SPRINT_SPEED = 11.0
const JUMP_VELOCITY = 5.0
const MOUSE_SENSITIVITY = 0.002

@onready var camera = $Camera3D
@onready var interaction_ray = $Camera3D/InteractionRay

var gravity = 9.8

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		if event.pressed and event.keycode == KEY_F:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

		if event.pressed and not event.echo and event.keycode == KEY_E:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				try_interact()

func try_interact():
	interaction_ray.force_raycast_update()

	if interaction_ray.is_colliding():
		var target = interaction_ray.get_collider()

		if target != null and target.is_in_group("vault"):
			target.interact()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var speed = WALK_SPEED

	if Input.is_key_pressed(KEY_SHIFT):
		speed = SPRINT_SPEED

	var direction = Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		direction.z -= 1

	if Input.is_key_pressed(KEY_S):
		direction.z += 1

	if Input.is_key_pressed(KEY_A):
		direction.x -= 1

	if Input.is_key_pressed(KEY_D):
		direction.x += 1

	direction = direction.normalized()
	direction = transform.basis * direction

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()