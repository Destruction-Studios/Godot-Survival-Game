extends CanvasLayer

@onready var panel_container = $%PanelContainer

func _ready():
	panel_container.pivot_offset = panel_container.size/2;
	var tween = create_tween();
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0);
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK);
	
	get_tree().paused = true;
	$%ContinueButton.pressed.connect(on_continue_pressed);
	$%QuitButton.pressed.connect(on_quit_button_pressed);


func set_defeat():
	$%TitleLabel.text = "Defeat";
	$%DescriptionLabel.text = "You Lose";
	play_jingle(true)

func set_victory():
	play_jingle()

func play_jingle(defeat:bool = false):
	if defeat:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()

func on_continue_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn");


func on_quit_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
