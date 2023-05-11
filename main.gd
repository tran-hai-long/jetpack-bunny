extends Node2D


var flying_enemy_scene = load("res://obstacles/flying_enemy.tscn")
var standing_enemy_scene = load("res://obstacles/standing_enemy.tscn")
var fast_enemy_scene = load("res://obstacles/fast_enemy.tscn")
var spike_up_scene = load("res://obstacles/spike_points_up.tscn")
var spike_down_scene = load("res://obstacles/spike_points_down.tscn")
var coin_scene = load("res://items/coin.tscn")
var warning_scene = load("res://obstacles/warning.tscn")

var screen_size
var min_interval = 0.5
var max_interval = 1.5
var speed = -400
var difficulty_scale = 1
var score = 0
var high_score_list


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	high_score_list = load_high_scores()
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_over():
	if len(high_score_list) < 10 or score > high_score_list[-1]:
		high_score_list.append(score)
		high_score_list.sort_custom(sort_descending)
		update_high_scores()
	var leftover_obstacles = get_tree().get_nodes_in_group("obstacles")
	for item in leftover_obstacles:
		item.queue_free()
	var leftover_items = get_tree().get_nodes_in_group("items")
	for item in leftover_items:
		item.queue_free()
	$Player.hide()
	get_tree().paused = true
	$HUD/StartButton.show()
	$HUD/HighScoreButton.show()
	$HUD/PauseButton.hide()


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
	$HUD/HighScoreButton.hide()
	$HUD/PauseButton.show()
	$HUD/Heading.hide()
	$HUD/Score.show()
	$Player.show()


func _on_difficulty_timer_timeout():
	difficulty_scale *= 1.1
	difficulty_scale = clamp(difficulty_scale, 1, 3)


func _on_spawn_timer_timeout():
	$Timer/SpawnTimer.wait_time = randf_range(min_interval, max_interval) / difficulty_scale
	var random_float = randf()
	if random_float < 0.7:
		generate_obstacle()
	elif random_float < 0.8:
		generate_fast_obstacle()
	else:
		generate_coin()


func _on_high_score_button_pressed():
	if not high_score_list.is_empty():
		$HUD/HighScoreList.clear()
		var count = 0
		for score in high_score_list:
			$HUD/HighScoreList.append_text(str(score))
			$HUD/HighScoreList.append_text("\n")
			count += 1
			if count >= 10:
				break
	$HUD/HighScoreList.show()
	$HUD/StartButton.hide()
	$HUD/HighScoreButton.hide()
	$HUD/BackButton.show()


func _on_back_button_pressed():
	$HUD/HighScoreList.hide()
	$HUD/StartButton.show()
	$HUD/HighScoreButton.show()
	$HUD/BackButton.hide()


func _on_pause_button_pressed():
	get_tree().paused = not get_tree().paused


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


func generate_fast_obstacle():
	var warning = warning_scene.instantiate()
	var position_y = randi_range($Ceiling.position.y, $Floor.position.y - warning.get_rect().size.y)
	warning.position.y = position_y
	warning.position.x = screen_size.x - warning.get_rect().size.x
	add_child(warning)
	await get_tree().create_timer(2.0).timeout
	warning.queue_free()
	var obstacle = fast_enemy_scene.instantiate()
	obstacle.position.y = position_y
	obstacle.position.x = screen_size.x
	obstacle.speed = speed * 2 * difficulty_scale
	add_child(obstacle)
	obstacle.game_over.connect(_on_game_over)



func generate_coin():
	var coin = coin_scene.instantiate()
	coin.position.y = randi_range($Ceiling.position.y, $Floor.position.y - coin.get_node("CoinCollision").shape.radius * 2)
	coin.position.x = screen_size.x
	coin.speed = speed * difficulty_scale
	add_child(coin)
	coin.get_coin.connect(_on_get_coin)


func load_high_scores():
	var high_score_list = []
	if  FileAccess.file_exists("user://highscores.save"):
		var save_game = FileAccess.open("user://highscores.save", FileAccess.READ)
		while save_game.get_position() < save_game.get_length():
			high_score_list.append(int(save_game.get_line()))
	return high_score_list


func update_high_scores():
	var save_game = FileAccess.open("user://highscores.save", FileAccess.WRITE)
	var count = 0
	for score in high_score_list:
		save_game.store_line(str(score))
		count += 1
		if count >= 10:
			break
	


func sort_descending(a, b):
	if a > b:
		return true
	return false
