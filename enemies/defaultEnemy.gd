extends CharacterBody3D

@export var speed = 25.0
@export_enum("default", "crazy") var enemy_type = "default"
@export_node_path("CharacterBody3D") var targetCharacter
var target:CharacterBody3D
var isHit = false
var initial_velocity
var time_until_death = 5
var total_time_until_death = time_until_death

func _ready():
	if(enemy_type=="default"):
		target = get_node(targetCharacter)
	if(enemy_type=="crazy"):
		velocity = ($moveTarget.position - position).normalized() * speed
		initial_velocity = velocity
	pass
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		burn()

func _physics_process(delta):
	#if(enemy_type == "crazy"):
		#if(is_any_colliding()):
			#rotate_y(randf_range(PI/2, 1.5*PI))
			#velocity = ($moveTarget.position - position).normalized() * speed
	if(enemy_type == "default"):
		if(isHit):
			velocity = target.position - position
			velocity.y = 0
	#print(velocity, target.position, position, target.position - position)
	velocity = velocity.normalized()
	velocity = velocity * speed

func _process(delta):
	$MeshInstance3D.look_at(position - velocity)

	if move_and_collide(velocity*delta):
		if(enemy_type == "crazy"):
			var x = randf_range(0, 1000)
			velocity = initial_velocity.rotated(Vector3(0, 1, 0), x).normalized() * speed
	
	if(isHit):
		time_until_death -= delta
		$MeshInstance3D.get_surface_override_material(0).albedo_color.a = time_until_death/total_time_until_death
		if(time_until_death < 1):
			$Fire/GPUParticles3D.emitting = false
		#$MeshInstance3D.get_surface_override_material(0).albedo_color.a = 0
		#$MeshInstance3D.surface_material_override.albedo_color.a = lerp($MeshInstance3D.surface_material_override.albedo_color.a, 0, 0.05)
		if(time_until_death <= 0):
			queue_free()
		

func burn():
	$Fire/GPUParticles3D.emitting = true
	isHit = true
