extends RigidBody3D

var base_angular_velocity = 50

func _ready():
	angular_velocity = Vector3(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0)).normalized()
	angular_velocity *= base_angular_velocity

func _physics_process(delta):
	pass

func _on_body_entered(body):
	if body.has_method("start_burning"):
		body.start_burning()

	# Get enemies in radius
	for overlapping_body in $Area3D.get_overlapping_bodies():
		if overlapping_body.get_meta("is_enemy", false) == true:
			overlapping_body.rekt()
