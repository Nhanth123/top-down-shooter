extends Control


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Space"):
		GameManager.load_game_scense()
