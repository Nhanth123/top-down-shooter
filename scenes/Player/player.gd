extends CharacterBody2D

class_name Player

const SPEED: float = 180




func _ready() -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
	rotation = velocity.angle()

func get_input():
	var nv = Vector2.ZERO
	nv.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	nv.y = Input.get_action_strength("down") - Input.get_action_strength("up") 
	velocity = nv.normalized() * SPEED
