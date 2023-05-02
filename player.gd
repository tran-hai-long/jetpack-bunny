extends RigidBody2D

var fly_speed = -1500
var flying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
