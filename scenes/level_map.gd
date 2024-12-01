extends Node2D


@onready var pickups: Node = $Pickups
@onready var game_ui: Control = $UI/GameUI

var _pickups_count: int = 0
var _collected: int = 0

func _ready() -> void:
	_pickups_count = pickups.get_children().size()
	game_ui.update_score(_collected, _pickups_count)
	SignalManager.on_pickup.connect(_on_pickup)
	SignalManager.on_exit.connect(_on_exit)
	SignalManager.on_game_over.connect(_on_game_over)


func check_show_exit() ->void:
	if _collected == _pickups_count:
		SignalManager.on_show_exit.emit()
		print("on_show_exit")


func _on_pickup() -> void:
	_collected += 1
	game_ui.update_score(_collected, _pickups_count)
	check_show_exit()


func stop_all_nodes():
	for n in get_tree().get_nodes_in_group("Bullet"):
		n.queue_free()
	
	var p = get_tree().get_first_node_in_group("Player")
	p.set_physics_process(false)
	
	for n in get_tree().get_nodes_in_group("NPC"):
		n.stop_action()

	
func _on_exit():
	stop_all_nodes()
	
func _on_game_over():
	stop_all_nodes()

		
