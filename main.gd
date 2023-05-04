extends Node2D

var min_interval = 1
var max_interval = 2
var interval = 1.5
var max_player_y
var min_player_y
var up_or_down = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interval -= delta
	if interval <= 0:
		calculate_max_distance()
		up_or_down = randi_range(0, 1)
		if up_or_down == 0:
			# TODO: generate obstacles so that player can go down
			pass
		elif up_or_down == 1:
			# TODO: generate obstacles so that player can go up
			pass
		up_or_down = -1
		generate_interval()

func _physics_process(delta):
	pass


func generate_interval():
	interval = randf_range(min_interval, max_interval)
	
func calculate_max_distance():
	max_player_y = $Player.y + ($Player.fly_speed * interval * interval) / 2
	min_player_y = $Player.y + (ProjectSettings.get_setting("physics/2d/default_gravity") * interval * interval) / 2
