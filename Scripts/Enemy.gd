extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const UP = Vector2(0,-1)
var motion = Vector2()

const GRAVITY = 20
var accel = 20
var maxSpeed = 100
var state = "walk"
var hp = 3
var routineInterrupted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	$walk_timer.start()


func _physics_process(delta):
	print(hp)
#	print($walk_timer.is_stopped())
#	print(hp)
#	print($damage_timer.is_stopped())
#	print($Sprite/AnimationPlayer.current_animation)
#	if routineInterrupted == false:
	_process_collisions()
#	if hp <= 0:
#		$Sprite/AnimationPlayer.play("Damage")
	
	if !$walk_timer.is_stopped() && routineInterrupted == false:
		if $Sprite.flip_h == false:
			motion.x = min(motion.x+accel,maxSpeed)
		else:
			motion.x = max(motion.x-accel,-maxSpeed)
	else:
		motion.x = 0
	motion.y += GRAVITY
	motion = move_and_slide(motion, UP) #return left over motion - 0,0 in this case

#
func _process_collisions():
	if routineInterrupted == false:
		var collisions = $AreaTop.get_overlapping_bodies()
		for collision in collisions:
			if collision.name == "Player" && collision._get_state() == "Jump":
				state = "damaged"
				routineInterrupted = true
				$damage_timer.start()
				_stop_timers_except("damage_timer")
				$Sprite/AnimationPlayer.play("Damage")
				collision.jump_off_enemy()
				if hp > 1:
					$Area2D/CollisionShape2D.disabled = true
					$DamageSound.play()
				else:
					$DeathSound.play()
				return
#		var collisions = $Area2D.get_overlapping_bodies()
#		for collision in collisions:
#			if collision.name == "Player":
#				state = "damaged"
#				routineInterrupted = true
#				$damage_timer.start()
#				_stop_timers_except("damage_timer")
#				$Sprite/AnimationPlayer.play("Damage")
#				if hp > 1:
#					$Area2D/CollisionShape2D.disabled = true
#					$DamageSound.play()
#				else:
#					$DeathSound.play()
#				return
		collisions = $Area2D.get_overlapping_areas()
		for collision in collisions:
			if collision.is_in_group("bullet"):
				collision.queue_free()
				state = "damaged"
				routineInterrupted = true
				$damage_timer.start()
				_stop_timers_except("damage_timer")
				$Sprite/AnimationPlayer.play("Damage")
				if hp > 1:
					$Area2D/CollisionShape2D.disabled = true
					$DamageSound.play()
				else:
					$DeathSound.play()
				return
		
				

#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
##		print("Collided with: ", collision.collider.name)
#		if collision.collider.name == "Player":
##				print("Player Collision detected")
#			state = "damaged"
#			routineInterrupted = true
#			$damage_timer.start()
#			_stop_timers_except("damage_timer")
#			$Sprite/AnimationPlayer.play("Damage")
#			if hp > 1:
#				$DamageSound.play()
#			else:
#				$DeathSound.play()
#				break
			
#func _collision_received():
#	if routineInterrupted == false:
#		state = "damaged"
#		routineInterrupted = true
#		$damage_timer.start()
#		_stop_timers_except("damage_timer")
#		$Sprite/AnimationPlayer.play("Damage")
#		if hp > 1:
#			$DamageSound.play()
#		else:
#			$DeathSound.play()
			
#
func _stop_timers_except(current):
	var childNodes = get_children()
	for node in childNodes:
#		print(node.get_name())
		if node.is_in_group("timer") && node.get_name() != current:
#			print(node.get_name())
			node.stop()

func _on_walk_timer_timeout():
	if routineInterrupted == false:
		$Sprite/AnimationPlayer.play("Idle")
		$idle_timer.start()
		state = "idle"


func _on_idle_timer_timeout():
	if routineInterrupted == false:
		$Sprite/AnimationPlayer.play("Attack")
		$attack_timer.start()
		state = "attack"
	


func _on_attack_timer_timeout():
	if routineInterrupted == false:
		if $Sprite.flip_h == true:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
		$Sprite/AnimationPlayer.play("Walk")
		$walk_timer.start()
		state = "walk"


func _on_damage_timer_timeout():
	$Area2D/CollisionShape2D.disabled = false
	hp = hp - 1
#	print(hp)
	if hp == 0:
#		print("TEST")
#		$DeathSound.play()
		queue_free()
	else:
		if $Sprite.flip_h == true:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
		$Sprite/AnimationPlayer.play("Walk")
		$walk_timer.start()
		state = "walk"	
		routineInterrupted = false
	

#
#func _on_Area2D_body_entered(body):
#	if routineInterrupted == false:
#		if body.name == "Player":
#			state = "damaged"
#			routineInterrupted = true
#			$damage_timer.start()
#			_stop_timers_except("damage_timer")
#			$Sprite/AnimationPlayer.play("Damage")
#			if hp > 1:
#				$Area2D/CollisionShape2D.disabled = true
#				$DamageSound.play()
#			else:
#				$DeathSound.play()

