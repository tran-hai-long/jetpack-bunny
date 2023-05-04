extends Node2D

var screen_size
var min_interval = 0.5
var max_interval = 2
var interval = 0.75
var obstacle
var flying_enemy_scene = load("res://obstacles/flying_enemy.tscn")
var standing_enemy_scene = load("res://obstacles/standing_enemy.tscn")
var spike_up_scene = load("res://obstacles/spike_points_up.tscn")
var spike_down_scene = load("res://obstacles/spike_points_down.tscn")
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD/ScoreTimer.start()
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interval -= delta
	if interval <= 0:
		generate_interval()
		generate_obstacle()
	score += roundi(delta * 100)


func _physics_process(delta):
	pass

func _on_game_over():
	get_tree().paused = true

func generate_interval():
	interval = randf_range(min_interval, max_interval)

func generate_obstacle():
	var obstacle_scale = randf_range(0.5, 2)
	var random_float = randf()
	if random_float < 0.6:
		obstacle = flying_enemy_scene.instantiate()
		obstacle.position.y = randi_range($Ceiling.position.y, $Floor.position.y - obstacle.get_node("FlyingEnemySprite").get_rect().size.y * obstacle_scale)
	elif random_float < 0.8:
		obstacle = spike_down_scene.instantiate()
		obstacle.position.y = $Ceiling.position.y
	elif random_float < 0.9:
		obstacle = spike_up_scene.instantiate()
		obstacle.position.y = $Floor.position.y - obstacle.get_node("SpikePointsUpSprite").get_rect().size.y * obstacle_scale
	else:
		obstacle = standing_enemy_scene.instantiate()
		obstacle.position.y = $Floor.position.y - obstacle.get_node("StandingEnemySprite").get_rect().size.y * obstacle_scale
	obstacle.position.x = screen_size.x
	obstacle.scale.x = obstacle_scale
	obstacle.scale.y = obstacle_scale
	add_child(obstacle)
	obstacle.game_over.connect(_on_game_over)


func _on_score_timer_timeout():
	$HUD/Score.text = "Score: " + str(score)
