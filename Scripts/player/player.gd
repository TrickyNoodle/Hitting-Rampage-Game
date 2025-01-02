extends CharacterBody2D
@onready var body
var jump=-300
var speed=275
var is_jumped=false
var attacked=false
var enemy_entered=[]
var health=20
func _physics_process(delta: float) -> void:
	velocity.y+=speed*delta
	if not velocity.x==0 and not $walk.playing and is_on_floor():
		$walk.play()
	elif velocity.y<0 and not $jump.playing:
		$jump.play()
	elif is_jumped and not $land.playing and is_on_floor() and not $walk.playing:
		$land.play()
	if health>1:
		if not is_on_floor():
			if velocity.y>0 and is_jumped==false:
				get_node("AnimatedSprite2D").play("jump_end");
				is_jumped=true
		var direction=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		if is_on_floor() and not direction and not Input.is_anything_pressed():
			get_node("AnimatedSprite2D").play("idle")
			is_jumped=false
		if direction:
			velocity.x = direction.x * speed
			if direction.x<0:
				get_node("AnimatedSprite2D").flip_h=true
				get_node("attack_area/CollisionShape2D_right").set_deferred("disabled",true)
				get_node("attack_area/CollisionShape2D_left").set_deferred("disabled",false)
				get_node("AnimatedSprite2D").play("run")
			elif direction.x>0:
				get_node("AnimatedSprite2D").flip_h=false
				get_node("attack_area/CollisionShape2D_left").set_deferred("disabled",true)
				get_node("attack_area/CollisionShape2D_right").set_deferred("disabled",false)
				get_node("AnimatedSprite2D").play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		if Input.is_key_pressed(KEY_UP) and is_on_floor():
			velocity.y = jump
			get_node("AnimatedSprite2D").play("jump_start")
			is_jumped=true
		move_and_slide()
		if Input.is_key_pressed(KEY_SPACE):
			get_node("AnimatedSprite2D").play("attack")
			if not $attack.playing:
				$attack.play()
			if $hit_timer.is_stopped():
				for enemy in enemy_entered:
					enemy.on_hit()
				$hit_timer.start()
	else:
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_entered.append(body)

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_entered.erase(body)

func on_hit(enemy :int) ->void:
	health-=2*enemy
	if not $hit.playing:
		$hit.play()
	get_parent().redraw_health(health)
