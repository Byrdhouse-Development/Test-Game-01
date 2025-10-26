extends Node2D

@export var waveSize : int = 5 # How many monsters spawn before the next wave is ready
@export var wave : int = 0 # The amount of waves that have begun
@export var currency : int = 0 # "Score" mechanic to track points to spend on upgrades

var enemyScene : PackedScene = preload("res://Assets/Scenes/Objects/enemy.tscn") # The enemy scene for spawning new enemies
@onready var spawnTimer : Timer = $SpawnTimer # Reference to the timer under the enemy scene

func _on_spawn_timer_timeout() -> void:
	var enemy = enemyScene.instantiate()
	get_tree().root.add_child(enemy) # This adds the enemy to the current scene to be spawned
	
	enemy.global_position =  _randomPosition()# Puts the new enemy at a random location
	

func _randomPosition() -> Vector2:
	var x : float = randf() * 576
	var y : float = randf() * 324
	var pos = Vector2(x,y)
	print(x)
	return pos
	
