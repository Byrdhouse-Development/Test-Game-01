extends CharacterBody2D

@export var maxHealth : float = 10 # Max health for the player
@export var health : float # Current health for the player
var prevHealth : float # Used to display health changes
var dirToPlayer : Vector2 # The path the robots will take towards the player
@export var speed : float = 10.0 # the speed at which the enemies move


@onready var player : Node2D = $"../Player" # A reference to the player object when the game starts
@onready var sprite : Sprite2D = $Sprite # Reference to the sprite of the enemy


func _ready() -> void:
	health = maxHealth
	prevHealth = health
	
func _process(delta: float) -> void:
	_healthBar() 
	
func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.y = 0
	_pathToPlayer()
	velocity.x = dirToPlayer.x * speed
	velocity.y = dirToPlayer.y * speed
	move_and_slide()
	
func _pathToPlayer() -> void:	
	dirToPlayer = player.global_position - global_position

func _healthBar() -> void:
	if health == 0:
		Global.currency += 1
		queue_free()
	if 	prevHealth != health:
		prevHealth = health
		sprite.modulate.r += 1 - (health / maxHealth) 
		sprite.modulate.g *= (health / maxHealth) * 1.2
		sprite.modulate.b *= (health / maxHealth) * 1.15
		
func _on_body_entered(body: Node2D) -> void:
	#Add code here for accounting for damage to the character the bullet hit
	print(body)
	if body.get_groups()[0] == "Player":
		body.health -= 1
		queue_free() # Destroys the bullet after it collides with something
	



var enemyScene : PackedScene = preload("res://Assets/Scenes/Objects/enemy.tscn") # The enemy scene for spawning new enemies
@onready var spawnTimer : Timer = $SpawnTimer # Reference to the timer under the enemy scene

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
	
