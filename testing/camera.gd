extends Camera3D

@export var camera_height = 30.0
@export var speed_fear_modifier = 0.1

@export var stickiness_x = 0.05
@export var stickiness_y = 0.05

var shake_until = 0
var shake_intensity = 0
var shaken_total = Vector3(0, 0, 0)

var transition = false

func _ready():
	State.turn_transition_on.connect(enable_transition)
	State.camera_shake.connect(shake)

func _process(delta):
	# Follow player on X-Z plane
	self.position.x = lerp(self.position.x, get_parent().get_node("Player").position.x, stickiness_x)
	self.position.z = lerp(self.position.z, get_parent().get_node("Player").position.z, stickiness_y)
	
	# Speed zoom out effect in Y axis
	var speed_fear = get_parent().get_node("Player").velocity.length() * speed_fear_modifier
	var target_camera_height = camera_height * (1 + speed_fear)
	if(transition):
		target_camera_height = $SucessTransition.global_position.y + 2
		translate(-shaken_total)
		shaken_total -= shaken_total
	self.position.y = lerp(self.position.y, target_camera_height, 0.1)
	
	
	if(shake_until > 0 && not transition):
		#var shake_by = randf_range(0, PI/50)*shake_intensity
		var shake_by = Vector3(shake_intensity*shake_until*randi_range(-1, 1), 0, shake_intensity*shake_until*randi_range(-1, 1))
		translate(shake_by)
		shaken_total += shake_by
		shake_until -= delta
		shake_intensity = -shake_intensity
	else:
		translate(-shaken_total*0.1)
		shaken_total -= shaken_total*0.1
		shaken_total = Vector3(0, 0, 0)

func shake(intensity, time):
	shake_until = time
	shake_intensity = intensity

func enable_transition(success):
	transition = true
	$SucessTransition.visible = success
	$FailureTransition.visible = not success
