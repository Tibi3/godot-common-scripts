## A Wrapper around [GCSObjectPool] to handle [Node]s.
##
## You can extend it and add as an autoload or use it on its own.
## [codeblock]
## extends GCSNodePool
##
##func _ready() -> void:
##	# set it here or in the inspector
##	max_size = 500
##	prewarm = 50
##
##	# These cannot be set in the inspector :(
##	# This will be called when the GCSNodePool needs more nodes.
##	initializer = func () -> Sprite2D:
##			var node := Sprite2D.new()
##			node.texture = preload("res://icon.svg")
##			return node
##
##	# This will be called when the borrowed node is returned to the GCSNodePool.
##	reset = func (sprite: Sprite2D) -> void:
##			sprite.position = Vector2.ZERO
##			sprite.texture = preload("res://icon.svg")
##
##
##	# Optionally you can override this method to get better type hints.
##	func borrow_node() -> Sprite2D:
##		return super()
## [/codeblock]
## Usage:
## [codeblock]
## var sprite := MyNodePool.borrow_node()
## add_child(sprite)
##
## # Do stuff
##
## # If you don't need it anymore return it.
## MyNodePool.return_node(sprite)
## [/codeblock]
## [br][b]Note[/b]: If you don't extend it you have to set the members before adding it to the [SceneTree].
## [codeblock]
## var node_pool: GCSNodePool
##
## func _ready() -> void:
##	node_pool = GCSNodePool.new()
##	node_pool.max_size = 500
##	node_pool.prewarm = 50
##	node_pool.initializer = ...
##	node_pool.reset = ...
##	add_child(node_pool)
## [/codeblock]
class_name GCSNodePool
extends Node

@export var max_size := 100
@export var prewarm := 10

var initializer: Callable
var reset: Callable = _default_reset

var _node_pool: GCSObjectPool

func _init() -> void:
	ready.connect(func (): _node_pool = GCSObjectPool.new(max_size, initializer, reset, prewarm))


func _exit_tree() -> void:
	_node_pool.free_node_pool()


func borrow_node() -> Node:
	var node := _node_pool.borrow_obj()

	if !is_instance_valid(node):
		return null

	return node


func return_node(node: Node) -> void:
	var parent := node.get_parent()
	if is_instance_valid(parent):
		parent.remove_child(node)

	_node_pool.return_node(node)


func _default_reset(node: Node):
	pass
