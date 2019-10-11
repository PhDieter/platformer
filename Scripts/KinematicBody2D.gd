extends KinematicBody2D

const UP = Vector2(0,-1)
var motion = Vector2()

var frames = 0
var hp = 3
var state
var sprint = false
var dash_ready = true
var airborne_post_dash
onready var current_Sprite = $Sprite_Jump
var grav_mod = 0
var currentInput = ""
var inputAccepted = true
var directionHeld = "0"

var wall_jump_ready = true
var wall_collision = false

var GRAVITY = 20
const FAST_FALL_GRAV_MOD = 1.30
var accel
var maxSpeed = 200
const TERMINAL_VELOCITY = 800
const BASE_ACCEL = 50
const AIR_ACCEL_MOD = 0.40
#backward air control slower than forward
const AIR_ACCEL_BACK_MOD = 0.4
const RUN_SPEED = 200
const SPRINT_SPEED = 300
const AIRBORNE_POST_DASH_SPEED = 300
const JUMP_HEIGHT = -550
const SHORT_JUMP_HEIGHT = -380
const DASH_SPEED = 125
#const SPRINT_AIR_SPEED = SPRINT_SPEED * 0.60
#const AIR_SPEED = RUN_SPEED

#var keyPressed = bool(false)
func _ready():
	pass
#	$Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _physics_process(delta):
	
#	process_collisions()
#	print(accel)
#	if Engine.get_time_scale() == 0.5:
#		GRAVITY = 10
#	if current_Sprite != null:
#		print(current_Sprite.get_name())
	if frames == 60:
		frames = 0
	else:
		frames += 1
#	print(frames)
#	print("Sprint?")
#	print(sprint)
#	print("Timer Stopped?")
#	print($sprint_timer.is_stopped())
#	print("Accel")
#	print(accel)
#	print(wall_jump_ready)

	if state == "Dash":
		if current_Sprite.flip_h == false:
			motion.x += DASH_SPEED
		else:
			motion.x -= DASH_SPEED
		motion.y = 0
	elif state == "Shoot":
#		motion.x = 0
		if is_on_floor():
			motion.x = lerp(motion.x, 0, 0.05)
		motion.y += GRAVITY + grav_mod
	else:
		motion.y += GRAVITY + grav_mod
		
	var friction = false
	
	accel = BASE_ACCEL
			
#	if position.y > get_viewport_rect().end.y:
#
##		queue_free()
#		pass
	if position.y > get_parent().bounds[3]:
		get_tree().reload_current_scene()
	
	
	
	
	
	if Input.is_action_pressed("ui_right"):
		
		directionHeld = "right"
		
		if state != "Dash" && state != "Shoot":
		#keyPressed = true
#			motion.x = min(motion.x+accel,maxSpeed)
			if is_on_floor():
				current_Sprite = $Sprite_Walk
				state = "Run"
				$CollisionShape2D_Jump1.set_rotation_degrees(15)
				$Sprite_Walk.flip_h = false
				$Sprite_Jump.flip_h = false
				#if Input.is_action_just_pressed("ui_right"):
				if !$StepSound.is_playing():
					$StepSound._set_playing(true)
#				check for dash
				if !$sprint_timer.is_stopped() && currentInput == "ui_right":
					sprint = true
					maxSpeed = SPRINT_SPEED
					$Sprite_Trail.show()
					$Sprite_Trail.position = Vector2(-20,20)
					$Sprite_Trail.flip_h = false;
					$Sprite_Trail/AnimationPlayer.play("Sprint_Start")
			else:
				accel *= AIR_ACCEL_MOD
				if current_Sprite.flip_h == true:
					accel *= AIR_ACCEL_BACK_MOD

			#$Sprite.play("Run")
			$Sprite_Jump.hide()
			$Sprite_Shoot.hide()
			$Sprite_Walk.show()
#			current_Sprite = $Sprite_Walk
			$Sprite_Walk/AnimationPlayer.play("Joe_Walk")
			motion.x = min(motion.x+accel,maxSpeed)
	elif Input.is_action_pressed("ui_left"):
		
		directionHeld = "left"
		
		if state != "Dash" && state != "Shoot":
			#keyPressed = true
#			motion.x = max(motion.x-accel,-maxSpeed)
			if is_on_floor():
				current_Sprite = $Sprite_Walk
				state = "Run"
				$CollisionShape2D_Jump1.set_rotation_degrees(-15)
				$Sprite_Walk.flip_h = true
				$Sprite_Jump.flip_h = true
				#if Input.is_action_just_pressed("ui_left"):
				if !$StepSound.is_playing():
					$StepSound._set_playing(true)
#				check sprint
				if !$sprint_timer.is_stopped() && currentInput == "ui_left":
					sprint = true
					maxSpeed = SPRINT_SPEED
					$Sprite_Trail.show()
					$Sprite_Trail.position = Vector2(20,20)
					$Sprite_Trail.flip_h = true;
					$Sprite_Trail/AnimationPlayer.play("Sprint_Start")
#					print("TEST")
			else:
				accel *= AIR_ACCEL_MOD
				if current_Sprite.flip_h == false:
					accel *= AIR_ACCEL_BACK_MOD

			#$Sprite.play("Run")
			$Sprite_Jump.hide()
			$Sprite_Shoot.hide()
			$Sprite_Walk.show()
#			current_Sprite = $Sprite_Walk
			$Sprite_Walk/AnimationPlayer.play("Joe_Walk")
			motion.x = max(motion.x-accel,-maxSpeed)

		
#	elif state != "Shoot":
#		#keyPressed = false
#		#motion.x = 0
#		#$Sprite.play("Idle")
#		$Sprite_Jump.hide()
#		$Sprite_Shoot.hide()
#		$Sprite_Walk.show()
#		current_Sprite = $Sprite_Walk
#		$Sprite_Walk/AnimationPlayer.play("Idle")
#		friction = true

	else:
		if is_on_floor() && state != "Shoot":
			$Sprite_Jump.hide()
			$Sprite_Shoot.hide()
			$Sprite_Walk.show()
			current_Sprite = $Sprite_Walk
			$Sprite_Walk/AnimationPlayer.play("Idle")
		friction = true
		
		
	if Input.is_action_just_pressed("ui_select") && dash_ready:
		if state != "Dash" && state != "Shoot":
			state = "Dash"
			$dash_timer.start()
			dash_ready = false
		#dash in direction held
			if Input.is_action_pressed("ui_right"):
				$Sprite_Walk.flip_h = false
				current_Sprite.flip_h = false
			elif Input.is_action_pressed("ui_left"):
				$Sprite_Walk.flip_h = true
				current_Sprite.flip_h = true
				
#			print(current_Sprite.get_name())
#			print(current_Sprite.flip_h)
			$DashSound.play()
			
			
	if Input.is_action_just_pressed("ui_down"):
		if !is_on_floor() && state != "Dash" && motion.y >= 0:
			grav_mod = GRAVITY*FAST_FALL_GRAV_MOD

	if state != "Dash" && state != "Shoot":
		
		
		if Input.is_action_just_pressed("ui_cancel"):# && state != "Shoot":
#			print(current_Sprite.get_name())
			state = "Shoot"
			dash_ready = false
			var new_bullet = preload("res://Scenes/Bullet.tscn").instance()
			get_parent().add_child(new_bullet)
			$shot_timer.start()
			$Sprite_Jump.hide()
			$Sprite_Walk.hide()
			$Sprite_Shoot.show()
			$Sprite_Shoot.flip_h = current_Sprite.flip_h
			current_Sprite = $Sprite_Shoot
			$Sprite_Shoot/AnimationPlayer.play("Shoot")
			$GunSound.play()
			if is_on_floor():
				motion.x = 0
#				motion.x = lerp(motion.x, 0, 0.05)
		
		
		if is_on_floor():# || is_on_wall():
			
			wall_jump_ready = true
			airborne_post_dash = false
#			if !sprint:
#				maxSpeed = RUN_SPEED
			accel = BASE_ACCEL
			grav_mod = 0
			dash_ready = true
			if Input.is_action_just_pressed("ui_accept"):
				if state != "Dash" && state != "Shoot":
					motion.y = JUMP_HEIGHT
				$JumpSound.play()
				$Sprite_Trail/AnimationPlayer.stop()
				$Sprite_Trail.hide()
				sprint = false
			elif Input.is_action_just_pressed("ui_focus_next"):
				if state != "Dash" && state != "Shoot":
					motion.y = SHORT_JUMP_HEIGHT
				$JumpSound.play()
				$Sprite_Trail.hide()
				$Sprite_Trail/AnimationPlayer.stop()
				sprint = false
#			elif Input.is_action_just_pressed("ui_cancel"):# && state != "Shoot":
#				state = "Shoot"
#				dash_ready = false
#				var new_bullet = preload("res://Scenes/Bullet.tscn").instance()
#				get_parent().add_child(new_bullet)
#				$shot_timer.start()
#				$Sprite_Jump.hide()
#				$Sprite_Walk.hide()
#				$Sprite_Shoot.show()
#				$Sprite_Shoot.flip_h = current_Sprite.flip_h
#				current_Sprite = $Sprite_Shoot
#				$Sprite_Shoot/AnimationPlayer.play("Shoot")
#				$GunSound.play()
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.20)
	#		if keyPressed == false:
	#			$Sprite_Walk/AnimationPlayer.play("Idle")
			$CollisionShape2D_Jump1.disabled = true
			$CollisionShape2D_Walk2.disabled = false
			$CollisionShape2D_Walk.disabled = false
			
			if Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_left"):
				$StepSound._set_playing(false)
				
			if Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right") && is_on_floor():
				if $sprint_timer.is_stopped():
					if !sprint:
						if Input.is_action_just_released("ui_left"):
							currentInput = "ui_left"
						else:
							currentInput = "ui_right"
						$sprint_timer.start()
					else:
						sprint = false
						currentInput = ""
						maxSpeed = RUN_SPEED
	
		else:
			if (state != "Shoot"):
				state = "Jump"
	#			accel *= AIR_ACCEL_MOD
				$StepSound._set_playing(false)
				if motion.y < 0:
					#$Sprite.play("Jump")
					$Sprite_Walk.hide()
					$Sprite_Shoot.hide()
					$Sprite_Jump.show()
					current_Sprite = $Sprite_Jump
					$CollisionShape2D_Jump1.disabled = false
					$CollisionShape2D_Walk2.disabled = true
					$CollisionShape2D_Walk.disabled = true
					$Sprite_Jump/AnimationPlayer.play("Joe_Jump")
				else:
					#$Sprite.play("Fall")
					$Sprite_Walk.hide()
					$Sprite_Shoot.hide()
					$Sprite_Jump.show()
					current_Sprite = $Sprite_Jump
					$Sprite_Jump/AnimationPlayer.play("Joe_Jump")
				if friction == true:
						motion.x = lerp(motion.x, 0, 0.05)
				
	#			wall jump
	#			print($wall_collide_area.get_overlapping_bodies())
				wall_collision = false
				for body in $wall_collide_area.get_overlapping_bodies():
	#				print(body.get_instance_id())
	#				print(last_wall_jumped)
					if body.get_name() == "TileMap":
						wall_collision = true
					if body.get_name() == "TileMap" && wall_jump_ready:# && body.get_position() != last_wall_jumped:
						
						
	#					print(body.get_tileset().get_tiles_ids())
	#					motion.y = 0
	#					wall_jump_ready = false
#						print("TileMap")
#						print(body.get_position().x)
#						print("Player")
#						print(position.x)
						if current_Sprite.flip_h == false:
#							if body.get_position().x > self.position.x:
							if Input.is_action_just_pressed("ui_accept"):
#								print(current_Sprite)
								if state != "Dash" && state != "Shoot":
									motion.y = JUMP_HEIGHT
									motion.x = -RUN_SPEED
								$JumpSound.play()
								sprint = false
								wall_jump_ready = false
								dash_ready = true
#								current_Sprite.flip_h == true
						if current_Sprite.flip_h == true:
#							if body.get_position().x < self.position.x:
							if Input.is_action_just_pressed("ui_accept"):
#								print(current_Sprite)
								if state != "Dash" && state != "Shoot":
									motion.y = JUMP_HEIGHT
									motion.x = RUN_SPEED
								$JumpSound.play()
								sprint = false
								wall_jump_ready = false
								dash_ready = true
#								current_Sprite.flip_h == false
								
						#flip sprite after wall jump
						if wall_jump_ready == false:
							if current_Sprite.flip_h == true:
								current_Sprite.flip_h = false
							else:
								current_Sprite.flip_h = true
	#					last_wall_jumped = body.get_position()					
	#					print("TEST")
						break
					
	#				print("TEST")
				if wall_collision == false:
					wall_jump_ready = true
#	print(get_tree().current_scene)
#	revert sprint speed if player has fallen off platform
#	print(motion.y)
	if motion.y > GRAVITY:
		sprint = false
	if motion.y == GRAVITY && !sprint:
		sprint = false
		if (!airborne_post_dash):
			maxSpeed = RUN_SPEED
			
	#terminal velocity
	motion.y = min(motion.y, TERMINAL_VELOCITY)
	
	
	if current_Sprite.flip_h == true:
		$wall_collide_area/CollisionShape2D.set_position(Vector2(-21,6))
	else:
		$wall_collide_area/CollisionShape2D.set_position(Vector2(10,5.75))
	
	#limit movement in level goal area
	if (inputAccepted):
		motion = move_and_slide(motion, UP) #return left over motion - 0,0 in this case
	else:
		motion.x = 0
		motion = move_and_slide(motion, UP) #return left over motion - 0,0 in this case		
	
	

	pass


func _slomo():
	GRAVITY = 10

func jump_off_enemy():
	motion.y = SHORT_JUMP_HEIGHT
	$JumpSound.play()
	$Sprite_Trail.hide()
	$Sprite_Trail/AnimationPlayer.stop()
	sprint = false

func _get_state():
	return state

func _on_ghost_timer_timeout():

	#delete previous ghost
#	for child in get_parent().get_children():
#		if child.is_in_group("ghost"):
#			child.queue_free()
	if (state == "Dash"):
		#instance ghost object
		var this_ghost = preload("res://Scenes/ghost.tscn").instance()
		#assign parent
		get_parent().add_child(this_ghost)
		this_ghost.position.x = position.x
		this_ghost.position.y = position.y
		if $Sprite_Walk.visible == true:
			var ghost_frame = $Sprite_Walk.frame
			this_ghost.set_texture($Sprite_Walk.get_texture())
	#		if Input.is_action_pressed("ui_left"):
	#			this_ghost.flip_h = true
			this_ghost.flip_h = $Sprite_Walk.flip_h
			this_ghost.set_region_rect(Rect2(ghost_frame*64,0,64,64))
			this_ghost.set_region(true)
		else:
			var ghost_frame = $Sprite_Jump.frame
			this_ghost.set_texture($Sprite_Jump.get_texture())
	#		if Input.is_action_pressed("ui_left"):
	#			this_ghost.flip_h = true
			this_ghost.flip_h = $Sprite_Jump.flip_h
			this_ghost.set_region_rect(Rect2(ghost_frame*64,0,64,64))
			this_ghost.set_region(true)

		
		
		
#func _process_collisions():
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
##		print("Collided with: ", collision.collider.name)
#		if collision.collider != null:
#			if collision.collider.name == "Enemy":
#				hp -= 1
#	#			print("function call")
#				collision.collider._collision_received()
#		#			print(hp)



func _on_dash_timer_timeout():
	
	
#	if dashDirection == "right":
#		current_Sprite.flip_h = false
#	else:
#		current_Sprite.flip_h = true
	motion.x = 0	
	if is_on_floor():
		state = "Idle"
		$Sprite_Walk/AnimationPlayer.play("Idle")
	else: 
		airborne_post_dash = true
		maxSpeed = AIRBORNE_POST_DASH_SPEED
		if current_Sprite.flip_h == false:
			motion.x = AIRBORNE_POST_DASH_SPEED
		else:
			motion.x = -AIRBORNE_POST_DASH_SPEED
#		maxSpeed = AIRBORNE_POST_DASH_SPEED
		state = "Jump"
		$Sprite_Jump/AnimationPlayer.play("Joe_Jump")
	

func _on_shot_timer_timeout():
	state = "Idle"
	$Sprite_Walk/AnimationPlayer.play("Idle")
	dash_ready = true


func _on_wall_collide_area_body_entered(body):
#	print($wall_collide_area.get_overlapping_bodies())
#	if body.get_name() == "TileMap":
#		if current_Sprite.flip_h == false:
#			if Input.is_action_just_pressed("ui_accept"):
#				if state != "Dash" && state != "Shoot":
#					motion.y = JUMP_HEIGHT
#				$JumpSound.play()
#				sprint = false
#				current_Sprite.flip_h = true
#		if current_Sprite.flip_h == true:
#			if Input.is_action_just_pressed("ui_accept"):
#				if state != "Dash" && state != "Shoot":
#					motion.y = JUMP_HEIGHT
#				$JumpSound.play()
#				sprint = false
#				current_Sprite.flip_h = false
	pass # Replace with function body.
