extends Node


const SAVE_FILE_PATH = "user://saves/game.save"

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
	load_save()

func load_save():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	print("Loading Save with value: ", save_data)


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	print("Saving wih value: ", save_data)
	file.store_var(save_data)

#TODO fix meta adding thing to both and figure out alg for the thing
func add_meta_upgrade(upgrade:MetaUpgrade):
	if not save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = DEFAULT_META_UPGRADE_DATA
		
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save()


func get_upgrade_count(id:String)->int:
	if MetaProgression.save_data["meta_upgrades"].has(id):
		return MetaProgression.save_data["meta_upgrades"][id]["quantity"]
	return 0


func on_xp_collected(number:float):
	save_data["meta_upgrade_currency"] += 500000;
	

func add_win():
	save_data["wins"] += 1

func add_loss():
	save_data["losses"] += 1


func calc_price(upgrade:MetaUpgrade):
	var result = upgrade.cost
	var count = get_upgrade_count(upgrade.id)
	
	if count >= 1:
		result += result * count * upgrade.cost_increase_per_level
	
	return round(result)
