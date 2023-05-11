extends Node2D

var screen_size
var min_interval = 0.5
var max_interval = 1.5
var interval = 0.75
var speed = -400
var difficulty_scale = 1
var flying_enemy_scene = load("res://obstacles/flying_enemy.tscn")
var standing_enemy_scene = load("res://obstacles/standing_enemy.tscn")
var spike_up_scene = load("res://obstacles/spike_points_up.tscn")
var spike_down_scene = load("res://obstacles/spike_points_down.tscn")
var coin_scene = load("res://items/coin.tscn")
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$HUD/Score.hide()
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	pass


func generate_obstacle():
	var obstacle
	var obstacle_scale = randf_range(0.5, 1.5)
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
	obstacle.speed = speed * difficulty_scale
	add_child(obstacle)
	obstacle.game_over.connect(_on_game_over)


func generate_coin():
	var coin = coin_scene.instantiate()
	coin.position.y = randi_range($Ceiling.position.y, $Floor.position.y - coin.get_node("CoinCollision").shape.radius * 2)
	coin.position.x = screen_size.x
	coin.speed = speed * difficulty_scale
	add_child(coin)
	coin.get_coin.connect(_on_get_coin)


func _on_game_over():
	var leftover_obstacles = get_tree().get_nodes_in_group("obstacles")
	for item in leftover_obstacles:
		item.queue_free()
	var leftover_items = get_tree().get_nodes_in_group("items")
	for item in leftover_items:
		item.queue_free()
	$Player.hide()
	get_tree().paused = true
	$HUD/StartButton.show()


func _on_get_coin():
	score += 100


func _on_score_timer_timeout():
	score += 1
	$HUD/Score.text = "Score: " + str(score)


func _on_start_button_pressed():
	get_tree().paused = false
	score = 0
	$Floor/FloorBackground.speed = speed
	difficulty_scale = 1
	$Timer/ScoreTimer.start()
	$Timer/DifficultyTimer.start()
	$Timer/SpawnTimer.start()
	$HUD/StartButton.hide()
	$HUD/Heading.hide()
	$HUD/Score.show()
	$Player.show()


func _on_difficulty_timer_timeout():
	difficulty_scale *= 1.1
	difficulty_scale = clamp(difficulty_scale, 1, 3)


func _on_spawn_timer_timeout():
	$Timer/SpawnTimer.wait_time = randf_range(min_interval, max_interval) / difficulty_scale
	var random_float = randf()
	if random_float < 0.8:
		generate_obstacle()
	else:
		generate_coin()
