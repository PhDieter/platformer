extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PoolIntArray) var bounds = [0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Fire1/AnimationPlayer.play("Idle")
	$Fire2/AnimationPlayer.play("Idle")
	
	$WarpInSound.play()
	$Enemy/Sprite/AnimationPlayer.play("Walk")
	
	#Set camera bounds
	var cam = $Player/Camera2D
	cam.limit_left = bounds[0]
	cam.limit_top = bounds[1]
	cam.limit_right = bounds[2]
	cam.limit_bottom = bounds[3]
#	cam.set_limit(cam.limit_left, bounds[0])
#	cam.set_limit(cam.limit_top, bounds[1])
#	cam.set_limit(cam.limit_right, bounds[2])
#	cam.set_limit(cam.limit_bottom, bounds[3])
		
#	print(cam.limit_left)
#	print(cam.limit_top)
#	print(cam.limit_right)
#	print(cam.limit_bottom)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
	
#	pass
