extends ParallaxBackground
var speed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	scroll_offset += Vector2(speed, 0) * delta
	if scroll_offset.x <= -256:
		scroll_offset = Vector2(0, 0)
