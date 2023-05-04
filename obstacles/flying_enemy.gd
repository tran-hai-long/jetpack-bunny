extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(-400, 0) * delta
	if position.x < (0 - $FlyingEnemySprite.get_rect().size.x):
		queue_free()
