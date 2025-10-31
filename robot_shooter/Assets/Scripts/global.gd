extends Node2D

@export var waveSize : int = 5 # How many enemies spawn before the next wave is ready
var waveCount : int = 0 # How many enemies have spawned this wave
@export var wave : int = 0 # The amount of waves that have begun
@export var currency : int = 0 # "Score" mechanic to track points to spend on upgrades

var enemyScene : PackedScene = preload("res://Assets/Scenes/Objects/enemy.tscn") # The enemy scene for spawning new enemies
@onready var spawnTimer : Timer = $SpawnTimer # Reference to the timer under the enemy scene

func _ready() -> void:
	wave += 1 # Set the initial wave number
	waveSize *= wave # Set inital wave size based on the wave

func _process(delta: float) -> void:
	if waveSize == waveCount:
		wave += 1 # Increase the wave number
		waveSize *= 2 # Change the nescessary size of the group according to the wave number
		waveCount = 0 # Reset the wave count for the new wave

func _on_spawn_timer_timeout() -> void:
	print("Timer over")
	waveCount += 1
	print(_randomPosition())
	
	# Enemy scene fails to instantiate because it has a reference to the player that fails to initialize

	#var enemy = enemyScene.instantiate()
	#get_tree().root.add_child(enemy) # This adds the enemy to the current scene to be spawned
	
	#enemy.global_position =  _randomPosition()# Puts the new enemy at a random location
	

func _randomPosition() -> Vector2:
	var x : float = randf() * 1152
	var y : float = randf() * 648
	var xNeg : float = randf()
	var yNeg : float = randf()
	if xNeg >= .51:
		x *= -1
	if yNeg >= .51:
		y *= -1
	var pos = Vector2(x,y)
	return pos
	
