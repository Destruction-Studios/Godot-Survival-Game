extends CanvasLayer

signal transition_halfway

var skip_emit = false

func transition():
	$AnimationPlayer.play("default")
	await transition_halfway
	skip_emit = true
	$AnimationPlayer.play_backwards("default")

func transition_to_scene(path:String):
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().change_scene_to_file(path)

func emit_half():
	if skip_emit:
		skip_emit = false
		return
	transition_halfway.emit()
