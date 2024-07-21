extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = get_parent().position.y + 20
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = get_parent().position.x
	position.z = get_parent().position.z
	pass
