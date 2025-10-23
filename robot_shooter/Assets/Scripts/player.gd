extends CharacterBody2D


@export var firerate : float = 0.1 # Determines how fast the player may shoot. In seconds (.1 = 10 times per second)
@export var currency : int = 0 # "Score" mechanic to track points to spend on upgrades
var lastShot : float # Used to maintain steady firerate

 
@onready var sprite : Sprite2D = $Player # Reference to the sprite of the player
@onready var bulletOrigin = $bulletOrigin # Location the bullet will spawn when fired
var bulletScene : PackedScene = preload("res://Assets/Scenes/Objects/bullet.tscn") # The bullet scene object to be created 

# Mouse tracking variables
var mousePos : Vector2

func _process(delta: float) -> void:
	# Allows the bullet aiming mechanism to follow around the player model
	var aimCenter = global_position
	var aimRad = 20 # Adjust this according to size of final sprite
	mousePos = get_global_mouse_position()
	var mouseDir = mousePos - aimCenter
	bulletOrigin.global_position = aimCenter + mouseDir.normalized() * aimRad
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
	get_tree().root.add_child(bullet) # This adds the bullet to the current scene to be spawned
	
	bullet.global_position = bulletOrigin.global_position # Puts the bullet at the location of the origin
	bullet.moveDir = mouseDir 
	
	
