extends Node2D

@export var waveSize : int = 5 # How many enemies spawn before the next wave is ready
var waveCount : int = 0 # How many enemies have spawned this wave
@export var wave : int = 0 # The amount of waves that have begun
@export var currency : int = 0 # "Score" mechanic to track points to spend on upgrades

func _ready() -> void:
	wave += 1 # Set the initial wave number
	waveSize *= wave # Set inital wave size based on the wave

func _process(delta: float) -> void:
	if waveSize == waveCount:
		wave += 1 # Increase the wave number
		waveSize *= 2 # Change the nescessary size of the group according to the wave number
		waveCount = 0 # Reset the wave count for the new wave

	

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
	
