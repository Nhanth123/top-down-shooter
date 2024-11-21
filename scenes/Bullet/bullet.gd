extends Area2D

const boom : PackedScene = preload("res://scenes/Boom/boom.tscn")
const speed: float = 250.0
var _dir_of_travel : Vector2 = Vector2.ZERO
var _target_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	look_at(_target_position)


func _process(delta: float) -> void:
	position += speed * delta * _dir_of_travel



func init(target: Vector2, start_pos:Vector2) -> void:
	_target_position = target
	_dir_of_travel = start_pos.direction_to(target)
	global_position = start_pos

func create_boom() -> void:
	var b = boom.instantiate()
	b.global_position = global_position
	get_tree().root.add_child(b)
	queue_free()


func _on_timer_timeout() -> void:
	create_boom()


func _on_body_entered(body: Node2D) -> void:
	create_boom()
