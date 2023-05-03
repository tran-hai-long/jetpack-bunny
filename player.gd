extends RigidBody2D

var fly_speed = -1500
var flying = false
var ceiling_overlapping_bodies
# Called when the node enters the scene tree for the first time.
func _ready():
	$BunnySprite.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flying:
		$FlameSprite.show()
	else:
		$FlameSprite.hide()

func _physics_process(delta):
	if Input.is_action_pressed("fly"):
		if not flying:
			flying = true
			set_linear_velocity(Vector2(0, 0))
		apply_central_force(Vector2(0, fly_speed))
	if Input.is_action_just_released("fly"):
		flying = false
	ceiling_overlapping_bodies = get_tree().current_scene.find_child("CeilingArea").get_overlapping_bodies()
	for body in ceiling_overlapping_bodies:
		if body.name == "Player":
			set_linear_velocity(Vector2(0, 0))

func _on_floor_area_body_entered(body):
	if(body.name == "Player"):
		$BunnySprite.play()


func _on_floor_area_body_exited(body):
	if(body.name == "Player"):
		$BunnySprite.stop()

