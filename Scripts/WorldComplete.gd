#WorldComplete
extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var targetCount = 0
var entered = false

export (String, FILE, "*.tscn") var next_world

func _ready():
	
	get_parent().get_node("WarpInSound").play(0.0)
	
	pass

func _physics_process(delta):
	
	targetCount = 0
	var childNodes = get_parent().get_children()
	for childNode in childNodes:
		if childNode.is_in_group("Target"):
			targetCount = targetCount + 1
	if targetCount == 0:
		self.set_visible(true)
		#self.get_child(1).set_disabled(false)
		self.get_node("CollisionShape2D").set_disabled(false)
	
	var bodies = get_overlapping_bodies()
	#print(bodies)
	if !entered:
		for body in bodies:
			if body.name == "Player":
				get_parent().get_node("WarpSound").play(0.0)
				entered = true
				#self.next_world
				$scene_change.start()
				get_parent().get_node("Player").inputAccepted = false
			
			
	pass



func _on_scene_change_timeout():
	entered = false
	get_parent().get_node("Player").inputAccepted = true
	get_tree().change_scene(next_world)
	
