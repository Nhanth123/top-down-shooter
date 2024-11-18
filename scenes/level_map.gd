extends Node2D


@onready var pickups: Node = $Pickups


var _pickups_count: int = 0
var _collected: int = 0

func _ready() -> void:
	_pickups_count = pickups.get_children().size()
	SignalManager.on_pickup.connect(_on_pickup)
	SignalManager.on_exit.connect(_on_exit)

func check_show_exit():
	if _collected == _pickups_count:
		SignalManager.on_show_exit.emit()
		print("on_show_exit")

func _on_pickup() -> void:
	_collected += 1
	check_show_exit()
	
func _on_exit():
	print("Game over", "win")
