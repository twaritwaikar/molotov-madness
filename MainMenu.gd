extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$WorldEnvironment.environment.sky_custom_fov += delta
	if(Input.is_anything_pressed()):
		get_tree().change_scene_to_file("res://testing/test_ground2.tscn")
	pass
