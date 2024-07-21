extends ProgressBar
#@onready var oxygenBar = $Oxygenbar

var no_of_molotvs = 1: set = _set_molotov

func _set_molotov(molotov):
	no_of_molotvs = molotov

var oxygen = 100: set = _set_oxy


func _set_oxy(new_oxy):
	oxygen = min(max_value, new_oxy)

func _init_oxygen(_oxygen):
	oxygen = _oxygen
	max_value = oxygen
	value = oxygen

## Called when the node enters the scene tree for the first time.
func _ready():
	_set_oxy(100)
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	oxygen -= (3.5 + 5*State.molotovs)*delta
	value = lerp(value, oxygen, 0.1)
	if oxygen < 10:
		State.decrease_health_by(delta*5)
		if Engine.get_frames_drawn() % 50 > 25:
			modulate.a = lerp(modulate.a, 0.0, 0.1)
			modulate.g = lerp(modulate.g, 0.0, 0.1) 
			modulate.b = lerp(modulate.b, 0.0, 0.1) 
		else:
			modulate.a = lerp(modulate.a, 1.0, 0.1) 
			modulate.g = lerp(modulate.g, 1.0, 0.1) 
			modulate.b = lerp(modulate.b, 1.0, 0.1) 
	elif oxygen <= 0 :
		State.finish_oxygen()

