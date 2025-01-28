extends CanvasLayer

@onready var panel_container: PanelContainer = %PanelContainer
@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton

var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")

var is_closing = false

func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size/2
	
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	
	$AnimationPlayer.play("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()
		close()


func close():
	if is_closing:
		return
	is_closing = true
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	await tween.finished

	get_tree().paused = false
	
	queue_free()


func on_options_pressed():
	var options_instance = options_menu_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_back.bind(options_instance))


func on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func on_options_back(options_menu:Node):
	options_menu.queue_free()


func on_resume_pressed():
	$AnimationPlayer.play_backwards("default")
	close()
