extends Node
class_name TimeManager

signal arena_difficulty_increased(current_arena_difficulty:int)
signal tick(tick_value:int)

const DIFFICULTY_INTERVAL = 5;

@export var end_screen_scene:PackedScene;
@onready var timer = $Timer

var tick_cooldown = 1
var tick_value = 0
var arena_difficulty = 0;

func _ready():
	timer.timeout.connect(on_timer_timeout);


func _process(delta):
	tick_cooldown -= delta
	if tick_cooldown <= 0:
		tick_value += 1
		tick.emit(tick_value)
		tick_cooldown = 1
		
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1;
		arena_difficulty_increased.emit(arena_difficulty);


func get_time_elapsed():
	return timer.wait_time - timer.time_left;


func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate();
	add_child(end_screen_instance);
	end_screen_instance.set_victory()
	
	MetaProgression.add_win()
	
	MetaProgression.save()
