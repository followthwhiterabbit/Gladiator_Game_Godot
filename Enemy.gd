extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 100




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var enemy_facing = "left"

@onready var gladiator = get_node("/root/World/gladiator")




func easy_ai():
	$AnimatedSprite2D.play("enemy_walk_left")
	velocity.x -= 10
	await get_tree().create_timer(5).timeout
	$AnimatedSprite2D.play("enemy_attack_left", 1)
	await get_tree().create_timer(5).timeout
	
	#if(health <= 0):
		#$AnimatedSprite2D.stop()
		
	


func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		
	if health < 50:
		$healthbar.modulate = Color(1, 0, 0)
		
	


func take_damage(attack_type):
	print("the function is called")
	$AnimatedSprite2D.animation = "hurt_left"
	$AnimatedSprite2D.play()
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "enemy_idle_left"
	$AnimatedSprite2D.play()
	
	if(attack_type == 1):
		health -= 10
	elif(attack_type == 2):
		health -= 20
	elif(attack_type == 3):
		health -= 30
	
		
	print(health)
	if(health <= 0):	
		$AnimatedSprite2D.animation = "dead_left"
		$AnimatedSprite2D.play()
		await get_tree().create_timer(1).timeout
		queue_free()



func _physics_process(delta):
	# Add the gravity.
	update_health()


	if gladiator:
		var  direction = (gladiator.position - position).normalized()
		velocity = direction * SPEED
		move_and_slide()

		var distance = gladiator.position.x - position.x
		
		print(distance)
		

		if(direction.x > 0):
			$AnimatedSprite2D.play("enemy_walk_right")	
		else:
			$AnimatedSprite2D.play("enemy_walk_left")				
			if(distance == -12):
				$AnimatedSprite2D.stop()
				$AnimatedSprite2D.play("enemy_attack_left")	

	
	#$AnimatedSprite2D.play("enemy_walk_left")
	#velocity.x -= 0.5
	
	
	
	
	if not is_on_floor():
		velocity.y += gravity * delta


	
	#var direction = Input.get_axis("ui_left", "ui_right")
	
	#velocity.x += 1
	



	## Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)





func _on_area_2d_body_entered(body):
	$AnimatedSprite2D.play("enemy_defend_left")
	
	if(body.is_in_group("character_hit")):
		easy_ai()
		body.take_damage()
	else:
		pass # Replace with function body.
