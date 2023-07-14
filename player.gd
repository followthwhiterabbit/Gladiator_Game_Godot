extends Area2D

@export var speed = 500

var screen_size


func _process(delta):
	var gravity = 80


	var velocity = Vector2.ZERO # the player's movement vector 


	velocity.y += gravity * delta
 

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$AnimatedSprite2D.animation = "walk"	
		$AnimatedSprite2D.play()
	elif Input.is_action_pressed("move_left"):
		velocity.x += -1	
		$AnimatedSprite2D.animation = "walk"	
		$AnimatedSprite2D.play()
	elif Input.is_action_just_pressed("jump"):
		velocity.y += -10
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.play()



	if velocity.length() != 0:
		velocity = velocity * speed 
		position += velocity * delta

	else:
		$AnimatedSprite2D.stop()


		
	









