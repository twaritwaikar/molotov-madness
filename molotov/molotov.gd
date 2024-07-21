extends RigidBody3D

var base_angular_velocity = 50
var has_hit_the_floor = false
var hitbox_lifetime = 1.0 # seconds
var should_dye = false
var default_hit_effect_radius = 0.5

var has_hit_player = false

func _ready():
	angular_velocity = Vector3(randf_range(0.5, 1.0), randf_range(0.5, 1.0), randf_range(0.5, 1.0)).normalized()
	angular_velocity *= base_angular_velocity
	$ThrowAudioStream.play()
	State.increase_molotovs()

func _physics_process(delta):
	pass

func _process(delta):
	if should_dye:
		hitbox_lifetime -= delta
		$OmniLight3D.light_energy = 3 * hitbox_lifetime
		if hitbox_lifetime < 0:
			State.decrease_molotovs()
			queue_free()

		# Get enemies in radius
		for overlapping_body in $Area3D.get_overlapping_bodies():
			if overlapping_body.get_meta("is_enemy", false) == true:
				if overlapping_body.has_method("is_burning"):
					if !overlapping_body.is_burning():
						overlapping_body.burn()
			if overlapping_body.get_meta("is_player", false) == true:
				if not has_hit_player:
					State.decrease_health_by(10)
					has_hit_player = true

func _on_body_entered(body):
	if has_hit_the_floor:
		return
		
	if body.get_meta("is_floor", false) == true:
		$Fire/GPUParticles3D.emitting = true
		$Impact/GPUParticles3D.emitting = true
		should_dye = true
		State.molotov_hit_ground()
		if $ThrowAudioStream.playing:
			$ThrowAudioStream.stop()
		if !$ExplodeAudioStream.playing:
			$ExplodeAudioStream.play()
	
	$BounceAudioStream.play()
