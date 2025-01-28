class_name WeightedTable;

var items:Array[Dictionary] = []
var total_weight = 0;

func add_item(item, weight:int):
	var data = {"item":item, "weight":weight}
	items.append(data)
	total_weight += weight;


func remove_item(item_to_remove):
	items = items.filter(func (item): return item["item"] != item_to_remove )
	
	total_weight = 0;
	for item in items:
		total_weight += item["weight"];


func pick_item(exculed: Array = []):
	var ajusted_items:Array[Dictionary] = items;
	var ajusted_total_weight = total_weight;
	if exculed.size() > 0:
		ajusted_items = []
		ajusted_total_weight = 0;
		for item in items:
			if item["item"] in exculed:
				continue;
			ajusted_items.append(item);
			ajusted_total_weight += item["weight"];
	
	var chosen_weight = randi_range(1, ajusted_total_weight)
	
	var iteration_sum = 0;
	for item in ajusted_items:
		iteration_sum += item["weight"];
		if chosen_weight <= iteration_sum:
			return item["item"];
