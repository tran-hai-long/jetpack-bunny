extends Node2D

var screen_size
var min_interval = 0.5
var max_interval = 2
var interval = 0.75
#var max_player_y
#var min_player_y
#var up_or_down = -1
var obstacle
var flying_enemy_scene = load("res://obstacles/flying_enemy.tscn")
var standing_enemy_scene = load("res://obstacles/standing_enemy.tscn")
var spike_up_scene = load("res://obstacles/spike_points_up.tscn")
var spike_down_scene = load("res://obstacles/spike_points_down.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interval -= delta
	if interval <= 0:
		generate_interval()
		var random_float = randf()
		if random_float < 0.6:
			obstacle = flying_enemy_scene.instantiate()
			obstacle.position.y = randi_range($Ceiling.position.y, $Floor.position.y)
		elif random_float < 0.8:
			obstacle = spike_up_scene.instantiate()
			obstacle.position.y = $Floor.position.y
		else:
			obstacle = spike_down_scene.instantiate()
			obstacle.position.y = $Ceiling.position.y
		obstacle.position.x = screen_size.x
		add_child(obstacle)
		#calculate_max_distance()
		#up_or_down = randi_range(0, 1)
#		if up_or_down == 0:
#			# TODO: generate obstacles so that player can go down
#			var flying_enemy = flying_enemy_scene.instantiate()
#			flying_enemy.position.x = screen_size.x
#			flying_enemy.position.y = randi_range($Ceiling.position.y, min_player_y)
#			add_child(flying_enemy)
#		elif up_or_down == 1:
#			# TODO: generate obstacles so that player can go up
#			var flying_enemy = flying_enemy_scene.instantiate()
#			flying_enemy.position.x = screen_size.x
#			flying_enemy.position.y = randi_range(max_player_y, $Floor.position.y)
#			add_child(flying_enemy)
#		up_or_down = -1

func _physics_process(delta):
	pass


func generate_interval():
	interval = randf_range(min_interval, max_interval)

#func calculate_max_distance():
#	max_player_y = $Player.position.y + ($Player.fly_speed * interval * interval) / 2
#	max_player_y = clamp(max_player_y, $Ceiling.position.y, $Floor.position.y)
#	min_player_y = $Player.position.y + (ProjectSettings.get_setting("physics/2d/default_gravity") * interval * interval) / 2
#	min_player_y = clamp(min_player_y, $Ceiling.position.y, $Floor.position.y)
