extends CharacterBody3D

@export var throw_power = 10

const SPEED = 10.0
var aiming = false

var molotov_scene = preload("res://molotov/molotov.tscn")
@onready var camera = get_parent().get_node("Camera3D")

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not aiming and event.pressed:
			start_aiming()
		if aiming and not event.pressed:
			end_aiming()

	# Always look towards the mouse
	if event is InputEventMouseMotion:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 100
		var cursor_position = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)

		self.look_at(cursor_position)

func _process(delta):
	pass

func start_aiming():
	aiming = true
	
	print("Start aiming")

func end_aiming():
	aiming = false
	_throw_molotov(transform.basis * Vector3.FORWARD + Vector3.UP * 0.5, throw_power)
	
	print("End aiming")

func _throw_molotov(direction: Vector3, power: float):
	var molotov_instance = molotov_scene.instantiate()
	molotov_instance.position = transform.origin + get_parent().position + Vector3(0, 2, 0)
	
	get_parent().add_child(molotov_instance)
	molotov_instance.apply_impulse(direction * power)
