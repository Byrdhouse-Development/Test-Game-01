extends Node

@export var nodeScene : PackedScene
var cachedNodes : Array[Node2D]

func _createNew() -> Node2D :
	var node = nodeScene.instantiate()
	cachedNodes.append(node)
	get_tree().get_root().add_child(node)
	return node

func spawn() -> Node2D:
	for node in cachedNodes:
		if node.visible == false:
			node.visible = true
			return node
	return _createNew()
