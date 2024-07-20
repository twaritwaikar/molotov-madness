extends RigidBody3D

func _process(delta):
	pass

func _physics_process(delta):
	pass

func _on_body_entered(body):
	if body.has_method("start_burning"):
		body.start_burning()

	# Get enemies in radius
	for overlapping_body in $Area3D.get_overlapping_bodies():
		if overlapping_body.get_meta("is_enemy", false) == true:
			overlapping_body.rekt()
