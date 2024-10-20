extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var nav_agent: NavigationAgent2D = $NavAgent

const SPEED: float = 60

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
	
	update_navigation()
	set_label()


func set_label():
	var debug_msg = ""
	debug_msg += "Done: \n" + str(nav_agent.is_navigation_finished())
	debug_msg += "Reachable: \n" + str(nav_agent.is_target_reachable())
	debug_msg += "Reached: \n" + str(nav_agent.is_target_reached())
	debug_msg += "Target: \n" + str(nav_agent.target_position)
	
	label.text = debug_msg

func update_navigation():
	if nav_agent.is_navigation_finished() == false:
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		sprite_2d.look_at(next_path_position)
		
		velocity = global_position.direction_to(next_path_position) * SPEED
		move_and_slide()
	
