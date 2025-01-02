extends Node2D
var Enemyboar=preload("res://Scripts/mobs/boar/enemy.tscn")
var score=0
var Enemybee=preload("res://Scripts/mobs/bee/bee.tscn")
const max_enemy=20
func _on_timer_timeout() -> void:
	if get_tree().get_node_count_in_group("enemy") < max_enemy:
		var enemy_type=randi_range(0,1)
		var enemy
		if enemy_type == 1 :
			enemy=Enemybee.instantiate()
			enemy.position.x=randf_range(0,3300)
			enemy.position.y=randf_range(650,1200)
		else:
			enemy=Enemyboar.instantiate()
			enemy.position.x=randf_range(0,3300)
			enemy.position.y=1200
		add_child(enemy)
	$Timer.start()

func increase_score(Enemyname: String):
	if Enemyname == "Boar":
		score+=10
	elif Enemyname == "Bee":
		score+=5
	$"Stats/Score".text="Score \n"+str(score)
	
func redraw_health(health: int) -> void:
	$Stats/HealthBar.value=health

func _ready() -> void:
	redraw_health($Player.health)
	$Player.position.x=randi_range(0,3300)
	$music.play()
	
func _on_child_exiting_tree(node: Node) -> void:
	if node.name=="Player":
		$Stats.visible=false
		$GameOver.visible=true
		Global.set_score(score)
		$GameOver/Score.text="Score\n"+str(score)


func _on_music_finished() -> void:
	$music.play()
