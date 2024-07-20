extends CharacterBody3D

const SPEED = 10.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var dragging = false
var click_radius = 32

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
		if not dragging and event.pressed:
			dragging = true
		if dragging and not event.pressed:
			dragging = false

	# Always look towards the mouse
	if event is InputEventMouseMotion:
		var camera: Camera3D = get_parent().get_node("Camera3D")
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 100
		var cursor_position = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)

		self.look_at(cursor_position)
