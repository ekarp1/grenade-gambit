extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var explodeTime = 0
const MAXEXPLODETIME = 2
const EXPLODEMAGNITUDE = 15

func _ready():
	var newMaterial = SpatialMaterial.new()
	newMaterial.albedo_color = Color(1, 0, 0)
	self.material_override = newMaterial

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(explodeTime < MAXEXPLODETIME):
		explodeTime += delta
	else:
		get_parent().remove_child(self)



func enteredExplosion(body):
	if(body == get_node("../Player")):
		body.apply_central_impulse(EXPLODEMAGNITUDE * get_global_transform().origin.direction_to(body.get_global_transform().origin))

