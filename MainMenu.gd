extends Node3D

var time_to_reveal = 1

func _ready():
	$MeshInstance2D.hide()
	$MESH.show()
	$MESH2.show()

func _process(delta):
	time_to_reveal -= delta
	if time_to_reveal < 0:
		$WorldEnvironment.environment.volumetric_fog_density = time_to_reveal
		
	$WorldEnvironment.environment.sky_custom_fov += delta
	if(Input.is_anything_pressed()):
		get_tree().change_scene_to_file("res://testing/test_ground2.tscn")
	pass
