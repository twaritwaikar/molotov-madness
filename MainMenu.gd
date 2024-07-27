extends Node3D

var time_to_reveal = 1
var time_to_close = 2
var is_closing = false
var basic_global_position_1
var basic_global_position_2

func _ready():
	basic_global_position_1 = $MESH/MeshInstance3D.global_position
	basic_global_position_2 = $MESH/MeshInstance3D2.global_position
	
	$WorldEnvironment.environment.volumetric_fog_enabled = true
	$MeshInstance2D.hide()
	
	$MESH/MeshInstance3D.show()
	$MESH/MeshInstance3D2.show()
	$MeshInstance3D3.show()
	$MESH.show()
	$MESH2.show()

func _process(delta):
	if OS.get_name() == "Android":
		$MeshInstance3D3.mesh.text = "Touch to start"
	time_to_reveal -= delta

	if time_to_reveal < 0:
		$WorldEnvironment.environment.volumetric_fog_density = time_to_reveal
		
	$WorldEnvironment.environment.sky_custom_fov += delta
	
	$MESH/MeshInstance3D.global_position.x = basic_global_position_1.x + 0.02 * sin(time_to_reveal)
	$MESH/MeshInstance3D.global_position.y = basic_global_position_1.y + 0.02 * cos(time_to_reveal)
	$MESH/MeshInstance3D2.global_position.x = basic_global_position_2.x + 0.02 * cos(time_to_reveal)
	$MESH/MeshInstance3D2.global_position.y = basic_global_position_2.y + 0.02 * sin(time_to_reveal)
	
	if(Input.is_action_just_pressed("start")):
		if !is_closing and !$AudioStreamPlayer2.is_playing():
			$AudioStreamPlayer2.play()
		is_closing = true
	
	if is_closing:
		time_to_close -= delta
		$WorldEnvironment.environment.volumetric_fog_density = 1.0 - pow(time_to_close, 2.0)
	
	if time_to_close < 0:
		get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if !is_closing and !$AudioStreamPlayer2.is_playing():
			$AudioStreamPlayer2.play()
		is_closing = true
