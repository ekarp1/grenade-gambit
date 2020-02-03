extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport_rect().size / 2
	get_viewport().connect("size_changed", self, "moveCrosshair")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func moveCrosshair():
	position = Vector2(floor(get_viewport_rect().size.x / 2), floor(get_viewport_rect().size.y / 2))
