extends Node3D

var time_to_reveal = 1
var time_to_close = 2
var is_closing = false
var basic_global_position

func _ready():
	basic_global_position = $Camera3D.global_position
	
	$WorldEnvironment.environment.volumetric_fog_enabled = true
	$MeshInstance2D.hide()
	
	$MESH/MeshInstance3D.show()
	$MESH/MeshInstance3D2.show()
	$MeshInstance3D3.show()
	$MESH.show()
	$MESH2.show()

func _process(delta):
	time_to_reveal -= delta

	if time_to_reveal < 0:
		$WorldEnvironment.environment.volumetric_fog_density = time_to_reveal
		
	$WorldEnvironment.environment.sky_custom_fov += delta
	
	$Camera3D.global_position.x = basic_global_position.x + 0.02 * sin(time_to_reveal)
	$Camera3D.global_position.y = basic_global_position.y + 0.02 * cos(time_to_reveal)
	
	if(Input.is_anything_pressed()):
		if !is_closing and !$AudioStreamPlayer2.is_playing():
			$AudioStreamPlayer2.play()
		is_closing = true
	
	if is_closing:
		time_to_close -= delta
		$WorldEnvironment.environment.volumetric_fog_density = 1.0 - pow(time_to_close, 2.0)
	
	if time_to_close < 0:
		get_tree().change_scene_to_file("res://testing/test_ground2.tscn")
