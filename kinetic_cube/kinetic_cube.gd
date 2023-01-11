extends RigidBody

onready var player_head: Spatial = get_node("/root/SceneManager/Gridbox/Player/Head")

func _on_bullet_hit(object_id, hit_position, hit_normal):
	if self.get_instance_id() == object_id:
		print("The kinetic_prop %s was hit!" % [self.get_instance_id()])
		
		self.apply_impulse(hit_position, -hit_normal * 30)

# Called when the node enters the scene tree for the first time.
func _ready():
	 player_head.connect("hit_kinetic_object", self, "_on_bullet_hit")
