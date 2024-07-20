extends RigidBody3D

var base_angular_velocity = 50
var has_hit_the_floor = false

func _ready():
	angular_velocity = Vector3(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0)).normalized()
	angular_velocity *= base_angular_velocity
	$ThrowAudioStream.play()

func _physics_process(delta):
	pass

func _process(delta):
	print($ExplodeAudioStream.playing)

func _on_body_entered(body):
	if has_hit_the_floor:
		return
		
	if body.get_meta("is_floor", false) == true:
		print("Floor hit!")
		# Start burning effects
		# Get enemies in radius
		for overlapping_body in $Area3D.get_overlapping_bodies():
			if overlapping_body.get_meta("is_enemy", false) == true:
				overlapping_body.rekt()

		if $ThrowAudioStream.playing:
			$ThrowAudioStream.stop()
		if !$ExplodeAudioStream.playing:
			$ExplodeAudioStream.play()
	else:
		$BounceAudioStream.play()