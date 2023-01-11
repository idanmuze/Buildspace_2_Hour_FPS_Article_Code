extends Control

signal replace_main_scene(resource)
signal can_play

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()
	
	yield(get_tree().create_timer(1.0), "timeout")
	$AnimationPlayer.play("Intro")
	yield(get_tree().create_timer(5.0), "timeout")
	$AnimationPlayer.play("Outro")
	yield(get_tree().create_timer(2.0), "timeout")
	
	get_parent().add_child(load("res://levels/gridbox/gridbox.tscn").instance())
	emit_signal("can_play")
	queue_free()
