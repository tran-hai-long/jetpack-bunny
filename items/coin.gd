extends Area2D


signal get_coin
var speed


# Called when the node enters the scene tree for the first time.
func _ready():
	$CoinAnimatedSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.name == "Player":
			get_coin.emit()
			queue_free()


func _physics_process(delta):
	position += Vector2(speed, 0) * delta
	if position.x < (0 - $CoinCollision.shape.radius * 4):
		queue_free()
