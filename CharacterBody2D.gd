extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var left_direction = false
var right_direction = false

var player_health = 100	
var attack_type = 1

func take_damage():
	player_health -= 10
	print("player took damage")
	
	if player_health <= 0:
		$AnimatedSprite2D.play("knight_dead_right", 8)	
		await get_tree().create_timer(0.1).timeout
		print("displays dead right")
		queue_free()
	else:
		$AnimatedSprite2D.play("knight_hurt_right")
		await get_tree().create_timer(0.1).timeout



func update_health():
	var healthbar = $player_health
	healthbar.value = player_health
	
	
	if player_health < 50:
		$player_health.modulate = Color(1.0, 0, 0)


	
func _physics_process(delta):

	$Area2D/attack_shape.disabled = true

	update_health()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	if Input.is_action_just_pressed("move_right"):
		velocity.x += 1
		right_direction = true
		left_direction = false
		$AnimatedSprite2D.animation = "walk_right"
		$AnimatedSprite2D.play()


	if Input.is_action_just_pressed("move_left"):
		velocity.x -= 1
		left_direction = true 
		right_direction = false
		$AnimatedSprite2D.animation = "walk_left"
		$AnimatedSprite2D.play()


	if (Input.is_action_just_pressed("jump") and right_direction == true):
		velocity.y += -100
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.play()
		print("jumped")
	
	if (Input.is_action_just_pressed("jump") and left_direction == true):
		velocity.y += -100
		$AnimatedSprite2D.animation = "knight_jump_left"
		$AnimatedSprite2D.play()
		print("jumped left")

	if (Input.is_action_just_pressed("attack") and right_direction == true):
		$Area2D/attack_shape.disabled = false
		$AnimatedSprite2D.play("attack", 7)

		print("attacked right")

	if (Input.is_action_just_pressed("attack") and left_direction == true):
		$Area2D/attack_shape.disabled = false
		$AnimatedSprite2D.play("attack_left", 7)
		print("attacked left")
	
	if (Input.is_action_just_pressed("defend") and right_direction == true):
		$Area2D/attack_shape.disabled = false
		$AnimatedSprite2D.play("defend", 4.5)
		print("defend right")

	if (Input.is_action_just_pressed("defend") and left_direction == true):
		$Area2D/attack_shape.disabled = false
		$AnimatedSprite2D.play("defend_left", 4.5)
		print("defend left")
		
	if (Input.is_action_just_pressed("attack_2") and right_direction == true):
		attack_type = 2
		$Area2D/attack_shape.disabled = false
		$AnimatedSprite2D.play("attack_2_right", 7)
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("idle_right")
		print("attack_2 right")

	
	if (Input.is_action_just_pressed("attack_2") and left_direction == true):
		attack_type = 2
		$Area2D/attack_shape.disabled = false
		$AnimatedSprite2D.play("attack_2_left", 7)
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("idle_left")
		print("attack_2 left")
	
		
	if (Input.is_action_just_pressed("attack_3") and right_direction == true):
		attack_type = 3
		$Area2D/attack_shape.disabled = false
		$AnimatedSprite2D.play("attack_3_right", 7)
		print("attack_3 right")


		
	if (Input.is_action_just_pressed("attack_3") and left_direction == true):
		attack_type = 3
		$Area2D/attack_shape.disabled = false
		$AnimatedSprite2D.play("attack_3_left", 7)
		print("attack_3 left")
	
	if Input.is_action_just_pressed("attack") and right_direction == true:
		attack_type = 1
		$Area2D/attack_shape.disabled = false
		#$AnimatedSprite2D.animation = "attack"

	if Input.is_action_just_pressed("attack") and left_direction == true:
		attack_type = 1
		$Area2D/attack_shape.disabled = false
		#$AnimatedSprite2D.animation = "attack"
		

	
	if Input.is_anything_pressed() == false:
		$AnimatedSprite2D.stop()
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()




func _on_area_2d_body_entered(body):
	if body.is_in_group("Hit"):
		body.take_damage(attack_type)		
	else:
		pass # Replace with function body.
