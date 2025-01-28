extends CanvasLayer

signal back_pressed

@onready var window_button: Button = %WindowButton
@onready var sfx_slider: HSlider = %SFXSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var back_button: Button = %BackButton


func _ready():
	back_button.pressed.connect(on_back_pressed)
	window_button.pressed.connect(on_window_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	
	update_display()

func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
		
	sfx_slider.value = get_bus_volume_perc("sfx")
	music_slider.value = get_bus_volume_perc("music")


func get_bus_volume_perc(bus_name:String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var vol_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(vol_db)


func set_bus_volume_perc(bus_name:String, perc:float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var vol_db = linear_to_db(perc)
	AudioServer.set_bus_volume_db(bus_index, vol_db)


func on_back_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	back_pressed.emit()


func on_audio_slider_changed(value:float, bus_name:String):
	set_bus_volume_perc(bus_name, value)


func on_window_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false);
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	update_display()
