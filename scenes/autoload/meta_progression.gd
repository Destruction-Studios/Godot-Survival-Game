extends Node

var DEFAULT_META_UPGRADE_DATA = {
	"quantity": 0
}

var save_data: Dictionary = {
	"wins": 0,
	"losses": 0,
	"enemies_killed": 0,
	
	"meta_upgrade_currency": 0,
	"meta_upgrades":{}
}

func _ready():
	GameEvents.experience_vial_collected.connect(on_xp_collected)


func add_meta_upgrade(upgrade:MetaUpgrade):
	if not save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = DEFAULT_META_UPGRADE_DATA
		
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1


func on_xp_collected(number:float):
	save_data["meta_upgrade_currency"] += number;
