extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var exit_label: Label = $MarginContainer/ExitLabel
@onready var time_label: Label = $MarginContainer/TimeLabel
@onready var game_over: Label = $ColorRect/GameOver
@onready var color_rect: ColorRect = $ColorRect

var _time: float = 0.0

func _ready() -> void:
	SignalManager.on_show_exit.connect(_on_show_exit)
	SignalManager.on_exit.connect(_on_exit)

func _process(delta: float) -> void:
	_time += delta
	time_label.text = "%.1fs" % _time

func update_score(act: int , target: int) -> void:
	score_label.text = "%s / %s" % [act, target]

func _on_show_exit():
	exit_label.show()

func _on_exit():
	set_process(false)
	color_rect.show()
	game_over.text = "Well done, you took: %.1f seconds" % _time
