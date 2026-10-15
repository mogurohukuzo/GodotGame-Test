extends CharacterBody2D

@export var speed: float = 200.0
@export var bullet_scene: PackedScene # インスペクターから弾のシーンをセットします

@onready var shoot_timer = $ShootTimer

func _physics_process(_delta: float) -> void:
	# 放置型の場合、基本は自動移動や簡易入力
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

# タイマーが0になるたびに自動で呼ばれる（シグナルを接続）
func _on_shoot_timer_timeout() -> void:
	shoot_nearest_enemy()

func shoot_nearest_enemy() -> void:
	# 画面内の「enemies」グループにいる敵を探す
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		return
		
	# 一番近い敵を探す
	var nearest_enemy: Node2D = null
	var min_dist = 999999.0
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest_enemy = enemy
			
	# 一番近い敵に向けて弾を発射
	if nearest_enemy and bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		# 敵への方向を計算
		bullet.direction = (nearest_enemy.global_position - global_position).normalized()
		get_tree().current_scene.add_child(bullet)
