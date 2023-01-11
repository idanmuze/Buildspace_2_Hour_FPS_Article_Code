extends Node



func _ready():
	go_to_title_screen()


func go_to_title_screen():
	var title_screen = ResourceLoader.load("res://user_interface/title_screen/title_screen.tscn")
	change_scene(title_screen)


func replace_main_scene(resource):
	call_deferred("change_scene", resource)


func change_scene(resource : Resource):
	var node = resource.instance()

	for child in get_children():
		remove_child(child)
		child.queue_free()
	add_child(node)
	
	node.connect("replace_main_scene", self, "replace_main_scene")
