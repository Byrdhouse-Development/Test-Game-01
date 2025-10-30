extends Area2D

@export var speed : float = 200 # Controls the speed of the bullet
@export var ownerGroup : String # Stores the character who spawned this bullet
@export var damage : int = 1 # Stores the damage of the bullet 

@onready var timer : Timer = $DestroyTimer # A timer to destroy the bullet 

var moveDir : Vector2 # A Vector that is used to store the direction of the bullet

func _process(delta: float) -> void:
	translate(moveDir * speed * delta)
	
func _on_body_entered(body: Node2D) -> void:
	#Add code here for accounting for damage to the character the bullet hit
	if body.get_groups()[0] == "Enemy" && ownerGroup == "Player":
		var parent = get_parent()
		parent.currency += 1
		queue_free() # Destroys the bullet after it collides with something

func _on_destroy_timer_timeout() -> void:
	queue_free() # Destroys the bullet when the timer ends
