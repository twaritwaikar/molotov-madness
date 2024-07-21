extends ProgressBar

@onready var timer = $Timer
@onready var damageBar = $DamageBar


var health = 0: set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	#
	#
	#if health<prev_health:
		#timer.start()
	#else:
		#damageBar.value = health
	
	

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damageBar.max_value = health
	damageBar.value = health
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_set_health(State.health)
	$DamageBar.value = lerp($DamageBar.value, value, 0.1)
	pass


func _on_timer_timeout():
	damageBar.value = health
	pass # Replace with function body.
