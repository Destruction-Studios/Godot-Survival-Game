extends CanvasLayer


func _ready():
	GameEvents.player_damaged.connect(on_player_damaged)
	$AnimationPlayer.play("RESET");
	

func on_player_damaged():
	$AnimationPlayer.play("hit");
