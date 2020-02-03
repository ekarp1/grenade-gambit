extends MeshInstance

func _ready():
	randomize()
	var newMaterial = SpatialMaterial.new()
	newMaterial.albedo_color = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), rand_range(0, 1))
	self.material_override = newMaterial
