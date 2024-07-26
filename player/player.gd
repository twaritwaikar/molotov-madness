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

func _ready():
	State.player_hit.connect(_get_hit)
	State.turn_transition_on.connect(_enable_transition)
	State.throw.connect(end_aiming)

func _get_hit():
	$HurtAudioStream.play()

func _enable_transition(alive):
	if not alive:
		queue_free()

func _physics_process(delta):	
	#var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir.y = Input.get_axis("ui_up", "ui_down")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	#var throw_dir = Input.get_vector("throw_left", "throw_right", "throw_up", "throw_down")
	#var throw_dir := Vector2.ZERO
	#throw_dir.x = Input.get_axis("throw_left", "throw_right")
	#throw_dir.y = Input.get_axis("throw_up", "throw_down")
	#var throw_direction = (Vector3(throw_dir.x, 1.2, throw_dir.y)).normalized()
	if State.throw_vector:
		self.look_at((State.throw_vector*10 + position))# - Vector3(camera.position.x, 0.0, camera.position.z))*10)
		#print("throw", State.throw_vector ))
	elif direction and State.is_android:
		self.look_at(direction*10 + position)
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
		var cursor_position = Plane.PLANE_XZ.intersects_ray(from, to)
		cursor_position -= Vector3(camera.position.x, 0.0, camera.position.z)
		if cursor_position:
			self.look_at(cursor_position)
			#print(cursor_position)

func _process(delta):
	footstep_time -= delta
	if footstep_time < 0 and !$WalkingAudioStream.is_playing() and !velocity.is_equal_approx(Vector3.ZERO):
		$WalkingAudioStream.play()
		footstep_time = default_footstep_time
	
	if aiming or State.throw_is_pressed:
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
	$GruntAudioStream.play()
