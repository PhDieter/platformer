extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const UP = Vector2(0,-1)
var motion = Vector2()
var speed_x = 0
var speed_y = 0

var player_node
var player_pos


# Called when the node enters the scene tree for the first time.
func _ready():
	
	player_node = get_parent().get_node("Player")
	player_pos = player_node.get_global_position()
	if player_node.current_Sprite.flip_h == false:
		set_global_position(Vector2(player_pos.x+25,player_pos.y-8))
#		if get_parent().slomo == false:
		speed_x = 30
#		else:
#			speed_x = 15
	else:
		set_global_position(Vector2(player_pos.x - 27,player_pos.y-8))
#		if get_parent().slomo == false:
		speed_x = -30
#		else:
#			speed_x = -15
#	set_position(Vector2(50,50))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):

	motion = Vector2(speed_x,speed_y)
	set_global_position(get_global_position()+motion) 
#	set_position(get_global_position() + motion * delta)
#	set_position(Vector2(20,20) + motion * delta)
	
#	print(get_position())