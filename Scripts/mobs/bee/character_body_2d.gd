extends CharacterBody2D
var attack
var chase
var player
var player_position=Vector2.ZERO
var health=5
var dead
var spawn_ended=false
func _physics_process(_delta: float) -> void:
	print()
	if health>0:
		if get_parent().get_node_or_null("Player")!=null:
			player_position=get_parent().get_node("Player").position
		var direction=(player_position-self.position).normalized()
		velocity.x=direction.x*75
		velocity.y=direction.y*75
		if direction.x>0:
			$Bee.flip_h=true
		elif direction.x<0:
			$Bee.flip_h=false
		if attack==true and $attackarea/ready.is_stopped():
			$Bee.play("attack")
			await $Bee.animation_finished
			if get_node("Timer").is_stopped() and attack:
				if get_parent().get_node_or_null("Player") !=null:
					get_parent().get_node("Player").on_hit(2)
					$attack.play()
				$Timer.start()
		else:
			if spawn_ended:
				$Bee.play("fly")
	else:
		if not dead:
			$Bee.play("hit")
			await $Bee.animation_finished
			dead=true
		self.queue_free()
	move_and_slide()
func _on_attackarea_body_entered(body: Node2D) -> void:
	if body.name=="Player":
		attack=true

func _on_attackarea_body_exited(body: Node2D) -> void:
	if body.name=="Player":
		attack=false
		$attackarea/ready.start()

func _ready() -> void:
	add_to_group("enemy")
	$Bee.play("spawn")
	await $Bee.animation_finished
	spawn_ended=true

func on_hit():
	$hit.play()
	health-=5

func _on_tree_exiting() -> void:
	get_parent().increase_score("Bee")
