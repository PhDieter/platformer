extends AudioStreamPlayer2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	print(get_parent().get_node("Player").get_node("Camera2D").get_global_position())
#	self.set_global_position(Vector2(OS.get_window_position().x+get_viewport().get_size().x/2,OS.get_window_position().y+get_viewport().get_size().y/2))
#	self.set_global_position(Vector2(get_parent().get_node("CanvasLayer").get_global_position().x,get_parent().get_node("CanvasLayer").get_global_position().y))