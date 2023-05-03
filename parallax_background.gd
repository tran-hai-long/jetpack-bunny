extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset += Vector2(-1, 0)
	# 3072 = the point at which background patterns repeat
	if scroll_offset == Vector2(-3072, 0):
		scroll_offset = Vector2(0, 0)
