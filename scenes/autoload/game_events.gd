extends Node

signal experience_vial_collected(number: float);
signal ability_upgrade_added(upgrade:AbilityUpgrade, currentUpgrades:Dictionary);
signal player_damaged();
signal speed_vial_collected()

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number);

func emit_speed_vial_collected():
	speed_vial_collected.emit()

func emit_ability_upgrade_added(upgrade:AbilityUpgrade, currentUpgrades:Dictionary):
	ability_upgrade_added.emit(upgrade, currentUpgrades);

func emit_player_damaged():
	player_damaged.emit();
