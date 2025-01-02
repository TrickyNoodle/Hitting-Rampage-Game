extends Node2D
func _ready() -> void :
	$sound.button_pressed=Global.sounds
	$Music.button_pressed=Global.music
	$music.play()

func _on_play_pressed() -> void:
	$accept.play()
	await $accept.finished
	get_tree().change_scene_to_file("res://Scripts/game/game.tscn")
	
func _on_exit_pressed() -> void:
	$exit.play()
	await $exit.finished
	get_tree().quit(0)
	

func _on_sound_toggled(toggled_on: bool) -> void:
	Global.toggle_sounds(toggled_on)

func _on_play_mouse_entered() -> void:
	$hover.play()

func _on_exit_mouse_entered() -> void:
	$hover.play()


func _on_music_finished() -> void:
	$music.play()


func _on_music_toggled(toggled_on: bool) -> void:
	Global.toggle_music(toggled_on)
	
func _on_name_mouse_entered() -> void:
	$Name.text="HighScore: "+str(Global.hscore)

func _on_name_mouse_exited() -> void:
	$Name.text="Killing Rampage!"
