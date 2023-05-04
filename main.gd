extends Node2D

var min_interval = 1
var max_interval = 2
var interval = 1.5
var max_distance_up
var max_distance_down

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass


func generate_interval():
	interval = randf_range(min_interval, max_interval)
	
func calculate_max_distance():
	max_distance_up = ($Player.fly_speed * interval * interval) / 2
	max_distance_down = (ProjectSettings.get_setting("physics/2d/default_gravity") * interval * interval) / 2
