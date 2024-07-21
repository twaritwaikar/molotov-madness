extends CharacterBody3D

@export var throw_power = 10

const default_footstep_time = 0.5 # seconds for 1 footstep
var footstep_time = default_footstep_time
const SPEED = 5.0
var aiming = false
var hold_duration = 0.0 # seconds
const MAX_HOLD = 1.0 # seconds
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
		if cursor_position:
			self.look_at(cursor_position)

func _process(delta):
	footstep_time -= delta
	if footstep_time < 0 and !$WalkingAudioStream.is_playing() and !velocity.is_equal_approx(Vector3.ZERO):
		$WalkingAudioStream.play()
		footstep_time = default_footstep_time
	
	if aiming:
		hold_duration += delta
		clampf(hold_duration, 0.0, MAX_HOLD)

func start_aiming():
	aiming = true

func end_aiming():
	var applied_power = hold_duration / MAX_HOLD
	_throw_molotov(transform.basis * Vector3.FORWARD + Vector3.UP * 3.0, throw_power * applied_power)
	
	aiming = false
	hold_duration = 0.0

func _throw_molotov(direction: Vector3, power: float):
	var molotov_instance = molotov_scene.instantiate()
	get_parent().add_child(molotov_instance)
	molotov_instance.position = transform.origin + get_parent().position
	molotov_instance.position.y = 3.5
	
	molotov_instance.linear_velocity = direction.normalized() * power * 5.0
	molotov_instance.linear_velocity.y = 1.0
	molotov_instance.apply_impulse(direction * power)
