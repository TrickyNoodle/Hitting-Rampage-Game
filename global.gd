extends Node
var music:bool
var sounds:bool
var hscore:int
func _process(_delta: float) -> void:
	if music:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),true)
	if sounds:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"),false)
	else :
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"),true)


func _ready() -> void:
	read()
		
func set_score(score :int):
	if hscore<=score:
		hscore=score
		save()
func save():
	var file=FileAccess.open("user://userdata.bin",FileAccess.WRITE)
	var data:Dictionary={
		"hscore":hscore,
		"music":music,
		"sounds":sounds
	}
	file.store_line(JSON.stringify(data))
func read():
	var file=FileAccess.open("user://userdata.bin",FileAccess.READ)
	if FileAccess.file_exists("user://userdata.bin"):
		if not file.eof_reached():
			var line=JSON.parse_string(file.get_line())
			hscore=line["hscore"]
			music=line["music"]
			sounds=line["sounds"]
	else:
		hscore=0
		music=true
		sounds=true

func toggle_music(value:bool):
	music=value
	save()
	
func toggle_sounds(value:bool):
	sounds=value
	save()
