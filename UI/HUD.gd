extends CanvasLayer

signal start_game

@onready var RightJoyStick = $VirtualJoyStickThrow

var throw_vector = Vector2.ZERO
var throw_was_pressed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#if(OS.get_name() != "Android"):
		#$VirtualJoyStickMove.use_input_actions = false
		#$VirtualJoyStickThrow.use_input_actions = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if RightJoyStick and RightJoyStick.is_pressed:
		throw_was_pressed = true
	else:
		if throw_was_pressed:
			throw_was_pressed = false
			State.call_throw(throw_vector)
	State.throw_is_pressed = RightJoyStick.is_pressed
	
	var throw_direction = (Vector3(RightJoyStick.output.x, 0, RightJoyStick.output.y)).normalized()
	#print(throw_direction)
	State.throw_vector = throw_direction
	#print(throw_direction)
