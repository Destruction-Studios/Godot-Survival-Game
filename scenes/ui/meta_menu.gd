extends CanvasLayer

@export var upgrades:Array[MetaUpgrade] = []

@onready var grid_container: GridContainer = %GridContainer

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")


func _ready():
	for child in grid_container.get_children():
		child.queue_free()
	
	for upgrade in upgrades:
		var inst = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(inst)
		inst.set_meta_upgrade(upgrade)
		
	%BackButton.pressed.connect(on_back_pressed)


func on_back_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
