# Player Controller
extends KinematicBody

const SPEED = 32
const TILE_SIZE = 8

var MOUSE_SENSITIVITY = 0.02 # radians/px

var move_direction = Vector3()
var last_position = Vector3()
var target_position = Vector3() #Global Space
var turn_degrees = 0
var target_rotation = Vector3()
var last_rotation = Vector3()
#var rotateLeft = 0
#var rotateRight = 0

var moving = false
var turning = false

var camera
var pitch_helper
var tween
#var grid
#var type
#var speed

func _ready():
	tween = $Tween
	pitch_helper = $Pitch_Helper
	camera = $Pitch_Helper/Camera
#	grid = get_parent()
#	type = grid.ENTITY_TYPES.PLAYER
	translation = translation.snapped((Vector3(TILE_SIZE, 0, TILE_SIZE)))
	last_position = translation
	target_position = translation
	turn_degrees = 0

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):
	# Turn
	if !turning:
		if Input.is_action_just_pressed("ui_page_up"):
			turn_left()
			turning = true
		if Input.is_action_just_pressed("ui_page_down"):
			turn_right()
			turning = true

	# Capture/Free the Mouse
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func process_movement(delta):
	# Movement
	translation += SPEED * move_direction * delta
	if translation.distance_to(last_position) >= TILE_SIZE:
		translation = target_position
	# if idle
	if translation == target_position:
		get_move_direction()
		last_position = translation
		target_position += move_direction * TILE_SIZE

# Control the camera with the mouse
# TODO: Only allow control while right click is held down, snap camera back to center on release
#func _unhandled_input(event):
#	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
#		$Pitch_Helper.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
#		$Pitch_Helper.rotation.x = clamp($Pitch_Helper.rotation.x, -1.2, 1.2)

func get_move_direction():
	var FORWARD = Input.is_action_pressed("ui_up")
	var BACKWARD = Input.is_action_pressed("ui_down")
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	
	move_direction.z = -int(FORWARD) + int(BACKWARD)
	move_direction.x = -int(LEFT) + int(RIGHT)
	move_direction = move_direction.rotated(Vector3(0,1,0), deg2rad(turn_degrees))

func turn_right():
	turn_degrees -= 90
#	rotate_y(deg2rad(turn_degrees))
	last_rotation = target_rotation
	target_rotation -= Vector3(0, 90, 0)
	tween.interpolate_property(self, "rotation_degrees", last_rotation, target_rotation, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func turn_left():
	turn_degrees += 90
#	rotate_y(deg2rad(turn_degrees))
	last_rotation = target_rotation
	target_rotation += Vector3(0, 90, 0)
	tween.interpolate_property(self, "rotation_degrees", last_rotation, target_rotation, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_completed(object, key):
	turning = false
