extends Node

const SPAWN_RADIUS = 330;
const MIN_SPAWN_RATE_DECREASE = .3;

@export var arena_time_manager:Node;
@export var enemies:Array[EnemyInfo];

@onready var timer = $Timer;

var base_spawn_time = 0;
var enemy_table = WeightedTable.new()

func _ready():
	for enemy in enemies:
		if enemy.spawn_at_difficulty == 0:
			enemy_table.add_item(enemy.enemy_scene, enemy.weight);
	
	base_spawn_time = timer.wait_time;
	timer.timeout.connect(on_timer_timeout);
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased);


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D;
	if player == null:
		return Vector2.ZERO;
	
	var spawn_position = Vector2.ZERO;
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
		var query_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params);
	
		if result.is_empty():
			break;
		else:
			random_direction = random_direction.rotated(deg_to_rad(90));
			
	return spawn_position

func on_timer_timeout():
	timer.start();
	var player = get_tree().get_first_node_in_group("player");
	if player == null:
		return;
	
	var enemy_scene = enemy_table.pick_item();
	var enemy = enemy_scene.instantiate();
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer");
	entities_layer.add_child(enemy);
	enemy.global_position = get_spawn_position();


func on_arena_difficulty_increased(arena_difficulty):
	var time_off = (.1 / 12) * arena_difficulty
	time_off = min(time_off, 1 - MIN_SPAWN_RATE_DECREASE)
	timer.wait_time = base_spawn_time - time_off
	
	for enemy in enemies:
		if enemy.spawn_at_difficulty == arena_difficulty:
			enemy_table.add_item(enemy.enemy_scene, enemy.weight);
