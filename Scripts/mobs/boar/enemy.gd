extends CharacterBody2D
var player=null
var chase=false
var health=5
var is_hit=false
var dead=false
func _physics_process(delta: float) -> void:
	if health<1 and not dead:
		dead=true
		$AnimatedSprite2D.play("death")
		$killed.play()
		await $AnimatedSprite2D.animation_finished
		self.queue_free()
	if not $AnimatedSprite2D.is_playing():
		if velocity.x!=0 and is_on_floor() and is_hit==false:
			$AnimatedSprite2D.play("run")
		elif is_hit:
			$AnimatedSprite2D.play("hit")
			await $AnimatedSprite2D.animation_finished
			is_hit=false
		else:
			$AnimatedSprite2D.play("idle")
	if not is_on_floor():
		velocity.y+=300*delta
	if chase and is_on_floor():
		var direction=(player.position-self.position).normalized()
		if direction.x>0:
			$AnimatedSprite2D.flip_h=true
		elif direction.x<0:
			$AnimatedSprite2D.flip_h=false
		velocity.x=direction.x*50
	else:
		velocity.x=0
	move_and_slide()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name=="Player":
		player=body
		chase=true
	
func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name=="Player":
		player=null
		chase=false

func on_hit() -> void:
	$hit.play()
	health-=2
	is_hit=true

func _ready() -> void:
	add_to_group("enemy")
	$AnimatedSprite2D.play("spawn")
	await $AnimatedSprite2D.animation_finished
	self.set_collision_layer_value(1,true)
	self.set_collision_layer_value(2,false)
	self.set_collision_mask_value(1,true)

func _on_enemy_top_body_entered(body: Node2D) -> void:
	if body.name=="Player":
		body.on_hit(1)

func _on_tree_exiting() -> void:
	get_parent().increase_score("Boar")
