extends ProgressBar

@onready var timer = $Timer

var oxygen = 100: set = _set_oxy

func _set_oxy(new_oxy):
	oxygen = min(max_value, new_oxy)
	value = oxygen
	
	
	if oxygen < 0:
		queue_free()



func _init_oxygen(_oxygen):
	oxygen = _oxygen
	max_value = oxygen
	value = oxygen

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
