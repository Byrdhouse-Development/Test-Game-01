extends Area2D

@export var speed : float = 200 # Controls the speed of the bullet
@export var ownerGroup : String # Stores the character who spawned this bullet
@export var damage : int = 3 # Stores the damage of the bullet 

@onready var timer : Timer = $DestroyTimer # A timer to destroy the bullet 

var moveDir : Vector2 # A Vector that is used to store the direction of the bullet

func _process(delta: float) -> void:
	translate(moveDir * speed * delta)
	
func _on_body_entered(body: Node2D) -> void:
	if body.get_groups()[0] == "Enemy" && ownerGroup == "Player":
		body.health -= damage
		visible = false # Hides the bullet between shots to minimize instantiation
		

func _on_destroy_timer_timeout() -> void:
	visible = false # Hides the bullet between shots to minimize instantiation

func _on_visibility_changed() -> void:
	if visible == true and timer:
		timer.start()
