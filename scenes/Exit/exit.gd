extends Area2D

func _ready() -> void:
	hide()
	SignalManager.on_show_exit.connect(_on_show_exit)

func _on_show_exit():
	set_deferred("monitoring", true)
	show()

func _on_body_entered(body: Node2D) -> void:
	SignalManager.on_exit.emit()
