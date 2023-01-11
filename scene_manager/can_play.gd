extends Node

signal can_play

var can_play := false

func _ready():
	connect("can_play", self, "_on_can_play")
		
func _on_can_play():
	can_play = true
