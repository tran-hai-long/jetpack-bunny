extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	scroll_offset += Vector2(-60, 0) * delta
	# 3072 = the point at which background patterns repeat
	if scroll_offset.x <= -3072:
		scroll_offset = Vector2(0, 0)
