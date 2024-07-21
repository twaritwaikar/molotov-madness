extends Node

var level_0 = preload("res://testing/test_ground2.tscn")
var levels =  [level_0]
var current_level = 0

var health
var molotovs
var oxygenFinish

signal camera_shake(intensity, time)
signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_variables()
	pass # Replace with function body.

func reset_variables():
	health = 100
	molotovs = 0
	oxygenFinish = false
	
func increase_molotovs():
	molotovs += 1
	
func decrease_molotovs():
	molotovs -= 1
	
func finish_oxygen():
	oxygenFinish = true

func is_oxygen_finished():
	return oxygenFinish
	
func decrease_health_by(value):
	player_hit.emit()
	health -= value
	if health < 0:
		reset_variables()
		get_tree().change_scene_to_packed(levels[current_level])

func molotov_hit_ground():
	camera_shake.emit(0.5, 1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
