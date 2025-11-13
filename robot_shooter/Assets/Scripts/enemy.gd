extends CharacterBody2D

@export var maxHealth : float = 10 # Max health for the player
@export var health : float # Current health for the player
var prevHealth : float # Used to display health changes
var dirToPlayer : Vector2 # The path the robots will take towards the player
@export var speed : float = 10.0 # the speed at which the enemies move
@export var firerate : float = .1 # Determines how fast the bullet may shoot. In seconds (.1 = 10 times per second)
@export var shotSpeed: float = 150 # Determines the speed the bullets move across the screen
var lastShot : float # Used to maintain steady firerate

@onready var player : Node2D = get_tree().get_first_node_in_group("Player") # A reference to the player object when the game starts
@onready var sprite : Sprite2D = $Sprite # Reference to the sprite of the enemy
@onready var bulletPool = $BulletPool
@onready var bulletOrigin = $BulletOrigin # Location the bullet will spawn when fired

func _ready() -> void:
	health = maxHealth
	prevHealth = health
	
func _process(delta: float) -> void:
	_healthBar() 
	_pathToPlayer()
	if Time.get_unix_time_from_system() - lastShot > firerate && visible:
		_fire()
	
func _physics_process(delta: float) -> void:
	velocity = dirToPlayer * speed
	move_and_slide()
	
func _pathToPlayer() -> void:	
	dirToPlayer = global_position.direction_to(player.global_position)

func _healthBar() -> void:
	if health <= 0:
		Global.currency += 1
		visible = false
	if 	prevHealth != health:
		prevHealth = health
		sprite.modulate.r += 1 - (health / maxHealth) 
		sprite.modulate.g *= (health / maxHealth) * 1.2
		sprite.modulate.b *= (health / maxHealth) * 1.15

var enemyScene : PackedScene = preload("res://Assets/Scenes/Objects/enemy.tscn") # The enemy scene for spawning new enemies
#@onready var spawnTimer : Timer = $SpawnTimer # Reference to the timer under the enemy scene

#func _on_spawn_timer_timeout() -> void:
#	print("Timer over")
#	waveCount += 1
#	print(_randomPosition())
#	
#	# Enemy scene fails to instantiate because it has a reference to the player that fails to initialize
#
#	#var enemy = enemyScene.instantiate()
#	#get_tree().root.add_child(enemy) # This adds the enemy to the current scene to be spawned
#	
#	#enemy.global_position =  _randomPosition()# Puts the new enemy at a random location
#	

func _fire() -> void:
	lastShot = Time.get_unix_time_from_system()
	
	var bullet = bulletPool.spawn()
	bullet.ownerGroup = "Enemy"
	bullet.speed = shotSpeed
	bullet.global_position = bulletOrigin.global_position # Puts the bullet at the location of the origin
	bullet.moveDir = dirToPlayer 


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
	


func _on_enemy_collision_body_entered(body: Node2D) -> void:
	if body.get_groups()[0] == "Player":
		body.health -= 1
		queue_free() # Destroys the bullet after it collides with something
	
