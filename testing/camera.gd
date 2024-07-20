extends Camera3D

@export var camera_height = 30.0
@export var speed_fear_modifier = 0.1

@export var stickiness_x = 0.05
@export var stickiness_y = 0.05

func _process(delta):
	# Follow player on X-Z plane
	self.position.x = lerp(self.position.x, get_parent().get_node("Player").position.x, stickiness_x)
	self.position.z = lerp(self.position.z, get_parent().get_node("Player").position.z, stickiness_y)
	
	# Speed zoom out effect in Y axis
	var speed_fear = get_parent().get_node("Player").velocity.length() * speed_fear_modifier
	var target_camera_height = camera_height * (1 + speed_fear)
	self.position.y = lerp(self.position.y, target_camera_height, 0.01)
