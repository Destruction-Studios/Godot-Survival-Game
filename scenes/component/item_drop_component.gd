extends Node

@export_range(0, 1) var drop_percent:float=.5
@export var does_exp_gain_work:bool=false
@export var health_component:HealthComponent
@export var drop_scene:PackedScene

func _ready():
	health_component.died.connect(on_died);


func on_died():
	var adjusted_drop = drop_percent
	var upgrade_count = MetaProgression.get_upgrade_count("experience_gain")
	if upgrade_count > 0:
		adjusted_drop += .1 * upgrade_count

	
	if randf() > adjusted_drop:
		return;
	
	if drop_scene == null:
		return;
	
	if not owner is Node2D:
		return
	
	var spawn_position = (owner as Node2D).global_position
	var dropped_item = drop_scene.instantiate() as Node2D;
	var entities_layer = get_tree().get_first_node_in_group("entities_layer");
	entities_layer.add_child(dropped_item)
	dropped_item.global_position = spawn_position
