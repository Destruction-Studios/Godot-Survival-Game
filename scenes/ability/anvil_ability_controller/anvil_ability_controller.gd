extends Node

const BASE_RANGE = 80
const BASE_DAMAGE = 15

@export var anvil_ability_scene:PackedScene

var anvil_count = 0

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player:
		return
		
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var rotate_amount = 360.0 / (anvil_count + 1)
	var random_extra_range = randf_range(0, BASE_RANGE)
	
	for i in anvil_count + 1:
		var rotated_direction = direction.rotated(deg_to_rad(i * rotate_amount))
		
		var spawn_position = player.global_position + rotated_direction * random_extra_range
		
		var query_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params);
		
		if !result.is_empty():
			spawn_position = result.position
			
		var anvil_scene = anvil_ability_scene.instantiate() as AnvilAbility
		get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_scene)
		anvil_scene.global_position = spawn_position
		anvil_scene.hitbox_component.damage = BASE_DAMAGE


func on_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id == "anvil_count":
		anvil_count = current_upgrades.anvil_count.quantity
