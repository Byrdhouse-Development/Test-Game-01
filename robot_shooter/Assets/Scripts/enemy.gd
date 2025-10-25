extends CharacterBody2D

@export var maxHealth : float = 10 # Max health for the player
@export var health : float # Current health for the player
var prevHealth : float # Used to display health changes
var dirToPlayer : Vector2 # The path the robots will take towards the player
@export var speed : float = 20.0 # the speed at which the enemies move

@onready var player = $"../Player" # A reference to the player object when the game starts
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
	if 	prevHealth != health:
		prevHealth = health
		sprite.modulate.r += 1 - (health / maxHealth) 
		sprite.modulate.g *= (health / maxHealth) * 1.2
		sprite.modulate.b *= (health / maxHealth) * 1.15
		
func _on_body_entered(body: Node2D) -> void:
	#Add code here for accounting for damage to the character the bullet hit
	print(body)
	if body.is_in_group("Player"):
		body.health -= 1
		queue_free() # Destroys the bullet after it collides with something
	
