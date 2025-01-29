extends Node

const SAVE_PATH = "user://saves/options.save"

const WINDOW_MODES = {
	WINDOWED = "windowed",
	FULLSCREEN = "fullscreen"
}

var options = {
	"sfx_volume":1,
	"music_volume":1,
}

func _ready():
	DirAccess.make_dir_absolute("user://saves")
	
	load_save()

func load_save():
	if not FileAccess.file_exists(SAVE_PATH):
		return;
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ);
	options = file.get_var();
	print("Loading Options with value: ", options)
	
	set_bus_volume_perc("sfx", options.sfx_volume)
	set_bus_volume_perc("music", options.music_volume)


func save():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE);
	print("Saving Options with value: ", options)
	file.store_var(options)


func set_bus_volume_perc(bus_name:String, perc:float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var vol_db = linear_to_db(perc)
	AudioServer.set_bus_volume_db(bus_index, vol_db)
