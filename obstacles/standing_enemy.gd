extends Area2D


signal game_over
var speed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.name == "Player":
			game_over.emit()


func _physics_process(delta):
	position += Vector2(speed, 0) * delta
	if position.x < (0 - $StandingEnemySprite.get_rect().size.x * 2):
		queue_free()
