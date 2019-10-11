#WorldComplete
extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hit = false

func _physics_process(delta):
	
	var bodies = get_overlapping_bodies()
	#print(bodies)
	for body in bodies:
		if hit == false:
			if body.name == "Player" || body.is_in_group("bullet"):
				$Sprite_Break/AnimationPlayer.play("Break")
				$TargetSound.play(0.0)
				hit = true
				
	var areas = get_overlapping_areas()
#	print(areas.size())
	for area in areas:
		if hit == false:
			if area.is_in_group("bullet"):
				$Sprite_Break/AnimationPlayer.play("Break")
				$TargetSound.play(0.0)
				hit = true
				area.queue_free()
				break
				
#				var children = get_parent().get_children()
#				for child in children:
#					if child.is_in_group("bullet"):
#						child.queue_free()
#						get_parent().delete(
				
			
	if !$Sprite_Break/AnimationPlayer.is_playing() && hit == true:
		self.queue_free()
			
	pass


