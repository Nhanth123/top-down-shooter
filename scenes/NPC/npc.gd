extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var player_detect: Node2D = $PlayerDetect
@onready var ray_cast_2d: RayCast2D = $PlayerDetect/RayCast2D
@onready var warning: Sprite2D = $Warning

@export var patrol_points: NodePath




const SPEED: float = 120

enum ENEMY_STATE { PATROLLING, CHASING, SEARCHING }


var _waypoints: Array = []
var _current_wp: int  = 0
var _player_ref : Player
var _state: ENEMY_STATE = ENEMY_STATE.PATROLLING

func _ready() -> void:
	set_physics_process(false)
	create_waypoint()
	_player_ref = get_tree().get_first_node_in_group("Player")
	call_deferred("set_physics_process", true)
	

func create_waypoint():
	for c in get_node(patrol_points).get_children():
		_waypoints.append(c.global_position)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
	
	raycast_to_player()
	update_state()
	update_movement()
	update_navigation()
	set_label()


func get_fov_angle() -> float:
	var direction = global_position.direction_to(_player_ref.global_position)
	var dot_p = direction.dot(velocity.normalized())
	if dot_p >= -1.0 and dot_p <= 1.0:
		return rad_to_deg(acos(dot_p))
	return 0.0

func player_in_fov() -> bool:
	return get_fov_angle() < 60.0


func raycast_to_player() -> void:
	player_detect.look_at(_player_ref.global_position)


func player_detected() -> bool:
	var c = ray_cast_2d.get_collider()
	if c != null:
		return c.is_in_group("Player")
	return false


func can_see_player() -> bool:
	return player_in_fov() and player_detected()

func set_nav_to_player():
	nav_agent.target_position = _player_ref.global_position


func process_patrolling() -> void:
	if nav_agent.is_navigation_finished() == true:
		navigate_wp()


func navigate_wp() -> void:
	if _current_wp >= len(_waypoints):
		_current_wp = 0
	nav_agent.target_position = _waypoints[_current_wp]
	_current_wp += 1

func process_chasing() -> void:
	set_nav_to_player()
	
func process_searching() -> void:
	if nav_agent.is_navigation_finished() == true:
		set_state(ENEMY_STATE.PATROLLING)

func set_state(new_state: ENEMY_STATE) -> void:
	if new_state == _state:
		return
	
	if _state == ENEMY_STATE.SEARCHING:
		warning.hide()
	
	if new_state == ENEMY_STATE.SEARCHING:
		warning.show()

	_state = new_state

func update_movement() -> void:
	match _state:
		ENEMY_STATE.PATROLLING:
			process_patrolling()
		ENEMY_STATE.SEARCHING:
			process_searching()
		ENEMY_STATE.CHASING:
			process_chasing()

func update_state() -> void:
	var new_state = _state
	var can_see = can_see_player()
	
	if can_see == true:
		new_state = ENEMY_STATE.CHASING
	elif can_see == false and new_state == ENEMY_STATE.CHASING:
		new_state = ENEMY_STATE.SEARCHING
	
	set_state(new_state)

func set_label():
	var debug_msg = ""
	debug_msg += "Done: " + str(nav_agent.is_navigation_finished()) + "\n"
	debug_msg += "Reachable: " + str(nav_agent.is_target_reachable()) + "\n"
	debug_msg += "Reached: " + str(nav_agent.is_target_reached()) + "\n"
	debug_msg += "Target: " + str(nav_agent.target_position) + "\n"
	debug_msg += "Player detected: " + str(player_detected()) + "\n"
	debug_msg += "Is in FOV: " + str(player_in_fov()) + "\n"
	debug_msg += "FOV: " + str(get_fov_angle()) + " " + ENEMY_STATE.keys()[_state] + "\n"
	label.text = debug_msg

func update_navigation():
	if nav_agent.is_navigation_finished() == false:
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		sprite_2d.look_at(next_path_position)
		
		velocity = global_position.direction_to(next_path_position) * SPEED
		move_and_slide()
	
