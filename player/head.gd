extends Spatial

export(NodePath) var cam_path := NodePath("Camera")
onready var cam: Camera = get_node(cam_path)

export var mouse_sensitivity := 2.0
export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()

# Custom shooting logic
var rng = RandomNumberGenerator.new()

signal hit_kinetic_object(object_id, hit_position)

const ray_length := 1000

var mouse_position : Vector2
var camera_origin : Vector3
var camera_target : Vector3

onready var shot_cooldown : Timer = get_node("../ShotCooldown")
var can_shoot := true
var can_shoot_2 := true

onready var anim_tree := $fps_pistol_animations/AnimationTree
onready var anim_player := $fps_pistol_animations/AnimationPlayer

onready var sound_player := $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg2rad(y_limit)
	
	rng.randomize()

# Called when there is an input event
func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()
		
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		mouse_position = event.position
		
	if event.is_action_released("shoot_gun"):
		can_shoot_2 = true
		
func _physics_process(_delta):
	var shot_fired = false 
	
	if Input.is_action_pressed("shoot_gun") && can_shoot && can_shoot_2:
		sound_player.unit_db = rng.randf_range(-16, -12)
		sound_player.pitch_scale = rng.randf_range(0.7, 0.75)
		sound_player.play()
		
		shot_fired = true
		
		camera_origin = cam.project_ray_origin(mouse_position)
		camera_target = camera_origin + cam.project_ray_normal(mouse_position) * ray_length
		
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(camera_origin, camera_target, [self, self.get_parent()])
		print(result)
		
		if !result.empty() :
			if result.collider.is_in_group("kinetic_props"):
				print(result.normal)
				emit_signal("hit_kinetic_object", result.collider_id, result.position, result.normal)
		
		can_shoot = false
		can_shoot_2 = false
		shot_cooldown.start()
		
	animation_update(shot_fired)
		
func animation_update(shot_fired: bool):
	var state_machine: AnimationNodeStateMachinePlayback = anim_tree["parameters/state_machine/playback"]

	if shot_fired && anim_tree["parameters/OneShot/active"]:
		print("Shot Fired!!!")
		anim_tree["parameters/Seek/seek_position"] = 0.0
		
	elif shot_fired:
		print("Shot Fired!")
		anim_tree["parameters/OneShot/active"] = true
		
	if Input.is_action_pressed("move_back") || Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
		state_machine.travel("walk")
	
	else:
		state_machine.travel("idle")

func camera_rotation() -> void:
	# Horizontal mouse look.
	rot.y -= mouse_axis.x * mouse_sensitivity
	# Vertical mouse look.
	rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	
	get_owner().rotation.y = rot.y
	rotation.x = rot.x


func _on_ShotCooldown_timeout():
	can_shoot = true
	print("Shot availiable!")
