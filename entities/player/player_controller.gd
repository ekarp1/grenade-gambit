extends RigidBody

##################################################

onready var explosionScene = preload("res://entities/Explosion/Explosion.tscn")
# Camera
export var mouse_sensitivity: float = 10.0
export var head_path: NodePath
onready var head: Spatial = get_node(head_path)
export var cam_path: NodePath
onready var cam: Camera = get_node(cam_path)
export var FOV: float = 80.0
var axis: Vector2 = Vector2()
# Move
var velocity: Vector3 = Vector3()
var direction: Vector3 = Vector3()
var mvarray: Array = [false, false, false, false] # FW, BW, L, R
var can_sprint: bool = true
var sprinting: bool = false
# Walk
export var gravity: float = 30.0
export var walk_speed: int = 20
export var sprint_speed: int = 16
export var acceleration: int = 8
export var deacceleration: int = 10
export var jump_height: int = 750
const FLOOR_NORMAL: Vector3 = Vector3(0, 1, 0)
# Fly
export var fly_speed: int = 10
export var fly_accel: int = 4
var flying: bool = false
# Slopes
export var floor_max_angle: float = 45
const VELOCITY_CLAMP: float = 0.25

##################################################

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.fov = FOV
	set_friction(1)




func _physics_process(delta: float) -> void:
	camera_rotation(delta)
	walk(delta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		axis = event.relative
	#Bullet Code
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var camera = get_node("Head/Camera")
		var raycast_from = camera.project_ray_origin(event.position)
		var raycast_to = raycast_from + camera.project_ray_normal(event.position) * 1000
		var raycast_result = get_world().direct_space_state.intersect_ray(raycast_from, raycast_to)
		if(raycast_result):
			var newExplosion = explosionScene.instance()
			newExplosion.set_translation(raycast_result.position)
			get_node("..").add_child(newExplosion)


func walk(delta: float) -> void:
	var moveForce = Vector3(0, 0, 0)
	# Input
	mvarray = [false, false, false, false]
	direction = Vector3()
	var aim: Basis = head.get_global_transform().basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
		mvarray[0] = true
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
		mvarray[1] = true
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
		mvarray[2] = true
	if Input.is_action_pressed("move_right"):
		direction += aim.x
		mvarray[3] = true
	direction.y = 0
	direction = direction.normalized()
	moveForce = direction * walk_speed
	
	#is the player on the ground?
	var grounded = false
	var raycast_result = get_world().direct_space_state.intersect_ray(get_global_transform().origin, Vector3(get_global_transform().origin.x, get_global_transform().origin.y - 1.5, get_global_transform().origin.z))
	if(raycast_result):
		grounded = true
	
	if Input.is_action_just_pressed("move_jump") and grounded:
		add_central_force(Vector3(0, jump_height, 0))
	
	# Move
	var linearVel = get_linear_velocity()
	if( ( abs(linearVel.x) + abs(linearVel.z) ) < 10):
		add_central_force(moveForce)


func camera_rotation(delta: float) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if axis.length() > 0:
		var mouse_x: float = -axis.x * mouse_sensitivity * delta
		var mouse_y: float = -axis.y * mouse_sensitivity * delta
		
		axis = Vector2()
		
		head.rotate_y(deg2rad(mouse_x))
		
		head.get_child(0).rotate_x(deg2rad(mouse_y))
		
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		head.rotation_degrees = temp_rot
