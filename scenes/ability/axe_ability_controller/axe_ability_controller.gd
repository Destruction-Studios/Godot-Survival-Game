extends Node

@export var axe_ability_scene:PackedScene;

var base_damage = 10;
var additional_damage_percent = 1;

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	var owned_meta_damage = MetaProgression.get_upgrade_count("extra_damage")
	if owned_meta_damage > 0:
		additional_damage_percent += .05 * owned_meta_damage

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return;
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D;
	
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = base_damage * additional_damage_percent


func on_ability_upgrade_added(upgrade:AbilityUpgrade, currentUpgrades:Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (currentUpgrades["axe_damage"]["quantity"] * .15)
