## Simliar to [GCSNodePool] but contains multiple pools.
##
## Add it to the [SceneTree] directly or extend it and add it as an autoload.
## [codeblock]
## # Add a Sprite2D Pool. You only have to do this once.
## multi_pool.add_pool(Sprite2D, GCSObjectPool.new(...))
## # Works with your types too.
## multi_pool.add_pool(Enemy, GCSObjectPool.new(...))
##
## # borrow the sprite
## var sprite := multi_pool.borrow_node(Sprite2D) as Sprite2D
##
## # Do stuff
##
## # After you don't need it anymore return it.
## multi_pool.return_node(Sprite2D, sprite)
## [/codeblock]
class_name GCSMultiNodePool
extends Node

var _node_pools: Dictionary[Variant, GCSObjectPool]

func _exit_tree() -> void:
	for pool in _node_pools:
		pool.free_node_pool()


func add_pool(type: Variant, pool: GCSObjectPool) -> void:
	assert(!_node_pools.has(type))
	_node_pools[type] = pool


func borrow_node(type: Variant) -> Node:
	var node := _node_pools[type].borrow_obj()

	if !is_instance_valid(node):
		return null

	return node


func return_node(type: Variant, node: Node) -> void:
	var parent := node.get_parent()
	if is_instance_valid(parent):
		parent.remove_child(node)

	_node_pools[type].return_node(node)
