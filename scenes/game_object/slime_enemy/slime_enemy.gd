extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component:VelocityComponent = $VelocityComponent

func _ready():
	$HurtboxComponent.hit.connect(on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delsta):
	velocity_component.accelerate_to_player();
	velocity_component.move(self);
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1);


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
