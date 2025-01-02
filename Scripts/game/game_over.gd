extends Panel

func _on_retry_pressed() -> void:
	$click.play()
	await $click.finished
	get_parent().get_tree().change_scene_to_file("res://Scripts/game/game.tscn")
	
func _on_exit_pressed() -> void:
	$exit.play()
	await $exit.finished
	get_parent().get_tree().change_scene_to_file("res://Scripts/menu/menu.tscn")

func _on_retry_mouse_entered() -> void:
	$hover.play()

func _on_exit_mouse_entered() -> void:
	$hover.play()

func _on_music_toggled(toggled_on: bool) -> void:
	Global.toggle_music(toggled_on)
	
func _on_sound_toggled(toggled_on: bool) -> void:
	Global.toggle_sounds(toggled_on)
	
func _ready() -> void:
	$sound.button_pressed=Global.sounds
	$Music.button_pressed=Global.music
