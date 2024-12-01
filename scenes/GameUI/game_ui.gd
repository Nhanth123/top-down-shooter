extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var exit_label: Label = $MarginContainer/ExitLabel
@onready var time_label: Label = $MarginContainer/TimeLabel
@onready var game_over: Label = $ColorRect/GameOver
@onready var color_rect: ColorRect = $ColorRect

var _time: float = 0.0
var _game_over: bool = false


func _ready() -> void:
	SignalManager.on_show_exit.connect(_on_show_exit)
	SignalManager.on_exit.connect(_on_exit)
	SignalManager.on_game_over.connect(_on_game_over)

func _process(delta: float) -> void:
	if _game_over  == false:
		_time += delta
		time_label.text = "%.1fs" % _time
	elif Input.is_action_just_pressed("Space"):
		GameManager.load_main_scene()
	

func update_score(act: int , target: int) -> void:
	score_label.text = "%s / %s" % [act, target]

func _on_show_exit():
	exit_label.show()

func _on_exit():
	set_process(false)
	_game_over = true
	color_rect.show()
	game_over.text = "Welcome done, You took  %1.f seconds" % _time


func _on_game_over():
	if _game_over == false:
		_game_over = true
		color_rect.show()
		game_over.text = "You lose, press [Space] to try again!"
		
