extends PanelContainer

@onready var name_label:Label = $%NameLabel;
@onready var description_label:Label = $%DescriptionLabel;
@onready var animation_player = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_label: Label = %ProgressLabel


var current_upgrade:MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchased_pressed)


func set_meta_upgrade(upgrade:MetaUpgrade):
	current_upgrade = upgrade
	
	name_label.text = upgrade.title;
	description_label.text = upgrade.description;
	update_progress()


func update_progress():
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	
	var percent = currency / current_upgrade.cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1
	
	progress_label.text = str(currency) + "/" + str(current_upgrade.cost)

func on_purchased_pressed():
	if current_upgrade == null:
		return
		
	
	MetaProgression.add_meta_upgrade(current_upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= current_upgrade.cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	
	animation_player.play("selected");
