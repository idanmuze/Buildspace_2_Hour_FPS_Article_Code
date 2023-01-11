extends Control

signal replace_main_scene(resource)

var ready_to_start = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# Intro 
	$Music.play()
	$AnimationPlayer.play("Intro")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Music_finished():
	if !ready_to_start:
		$Music.play()


func _on_Message_Timer_timeout():
	$AnimationPlayer.play("Blink")
	ready_to_start = true

func _input(event):
	if event is InputEventMouseButton && event.pressed && event.button_index == 1 && ready_to_start:
		$Music.stop()
		$ClickSound.play()
		
		# Outro
		yield(get_tree().create_timer(1.0), "timeout")
		$AnimationPlayer.play("Outro")
		yield(get_tree().create_timer(3.0), "timeout")
		
		# Switch scenes
		emit_signal("replace_main_scene", ResourceLoader.load("res://user_interface/loading_screen/loading_screen.tscn"))
		
		
func scene_transition():
	pass
		
