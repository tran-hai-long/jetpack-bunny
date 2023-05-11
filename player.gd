extends RigidBody2D


@export var fly_speed = -1500
enum {
	STATE_RUNNING,
	STATE_FLYING,
	STATE_FALLING
}
var state = STATE_FALLING


# Called when the node enters the scene tree for the first time.
func _ready():
	$BunnySprite.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	match state:
		STATE_RUNNING:
			if Input.is_action_pressed("fly"):
				state = STATE_FLYING
				set_linear_velocity(Vector2(0, 0))
				apply_central_force(Vector2(0, fly_speed))
				$JetpackParticles.emitting = true
		STATE_FLYING:
			if Input.is_action_pressed("fly"):
				apply_central_force(Vector2(0, fly_speed))
			else:
				state = STATE_FALLING
				$JetpackParticles.emitting = false
		STATE_FALLING:
			if Input.is_action_pressed("fly"):
				state = STATE_FLYING
				set_linear_velocity(Vector2(0, 0))
				apply_central_force(Vector2(0, fly_speed))
				$JetpackParticles.emitting = true
			elif linear_velocity == Vector2(0, 0):
				state = STATE_RUNNING
				$JetpackParticles.emitting = false


func _on_floor_area_body_entered(body):
	if(body.name == "Player"):
		$BunnySprite.play()


func _on_floor_area_body_exited(body):
	if(body.name == "Player"):
		$BunnySprite.stop()


func _on_ceiling_area_player_collided():
	set_linear_velocity(Vector2(0, 0))
