extends CharacterBody2D

#Base Gun Mechanics: I plan to move these mechanics over to the bullet origin object 
@export var firerate : float = 0.1 # Determines how fast the player may shoot. In seconds (.1 = 10 times per second)
@export var shotSpeed: float = 200 # Determines the speed the bullets move across the screen
var lastShot : float # Used to maintain steady firerate
@onready var bulletOrigin = $bulletOrigin # Location the bullet will spawn when fired

@export var maxHealth : float = 10 # Max health for the player
@export var health : float # Current health for the player
var prevHealth : float # Used to display health changes
@export var maxWave : int = 0 # The number of waves that have been completed each round
@onready var sprite : Sprite2D = $Sprite # Reference to the sprite of the player

var bulletScene : PackedScene = preload("res://Assets/Scenes/Objects/bullet.tscn") # The bullet scene object to be created 

# Mouse tracking variables
var mousePos : Vector2

func _ready() -> void:
	health = maxHealth
	prevHealth = health

func _process(delta: float) -> void:
	# Allows the bullet aiming mechanism to follow around the player model
	var aimCenter = global_position
	var aimRad = 20 # Adjust this according to size of final sprite
	mousePos = get_global_mouse_position()
	var mouseDir = mousePos - aimCenter
	bulletOrigin.global_position = aimCenter + mouseDir.normalized() * aimRad
	_healthBar()
	# Checks to see if the fire button is pressed
	if Input.is_action_pressed("Fire"):
		if Time.get_unix_time_from_system() - lastShot > firerate:
			_fire()

# Fire function that creates and shoots the projectile after the button is pressed
func _fire() -> void:
	mousePos = get_global_mouse_position()
	var mouseDir = bulletOrigin.global_position.direction_to(mousePos)
	lastShot = Time.get_unix_time_from_system()
	
	var bullet = bulletScene.instantiate()
	bullet.ownerGroup = "Player"
	bullet.speed = shotSpeed
	get_tree().root.add_child(bullet) # This adds the bullet to the current scene to be spawned
	
	bullet.global_position = bulletOrigin.global_position # Puts the bullet at the location of the origin
	bullet.moveDir = mouseDir 

func _healthBar() -> void:
	if 	prevHealth != health:
		prevHealth = health
		sprite.modulate.r += 1 - (health / maxHealth) 
		sprite.modulate.g *= (health / maxHealth) * 1.2
		sprite.modulate.b *= (health / maxHealth) * 1.15
		
