## An Object Pool
##
## It is recommneded to use [GCSNodePool] or [GCSMultiNodePool].[br][br]
## [b]Note[/b]: If you decided to use this directly don't forget to call [method free_object_pool] when you are done.[br]
## [b]Note[/b]: If you store [RefCounted] you don't have to call [method free_object_pool].
class_name GCSObjectPool

var _objects: Array[Object]
var _free_objects: Array[Object]
var _initializer: Callable
var _reset: Callable
var _max_size: int

## [param p_max_size]: The maximum number of objects the pool can store.
## [method borrow_obj] will return null if more than [param p_max_size] borrowed.[br]
## [param p_initializer]: [code]func () -> Object[/code]. Constructs one object.[br]
## [param p_reset]: [code]func (object) -> void[/code]. Resets an object, called when the object is returned.[br]
## [param p_prewarm]: Creates this many objects on init.[br]
func _init(p_max_size: int, p_initializer: Callable, p_reset: Callable, p_prewarm: int) -> void:
	_max_size = p_max_size
	_initializer = p_initializer
	_reset = p_reset

	assert(_initializer.is_valid(), "initializer is not valid in ObjectPool. Maybe you forgot to set the initializer in GCSNodePool?")

	for _i in mini(p_max_size, p_prewarm):
		var object := _initializer.call() as Object
		assert(is_instance_valid(object), "_initializer returned null in ObjectPool.")
		_objects.push_back(object)

	_free_objects.append_array(_objects)


## Borrows an object. Returns [code]null[/code] if [member max_size] is reached.
func borrow_obj() -> Object:
	if _free_objects.is_empty():
		if _objects.size() >= _max_size:
			return null

		var new = _initializer.call()
		assert(is_instance_valid(new), "_initializer returned null in ObjectPool.")
		_objects.push_back(new)
		return new

	var object := _free_objects.pop_back() as Object
	assert(is_instance_valid(object), "Object got freed from outside in ObjectPool.")

	return object

## Returns [param object] to the ObjectPool. Automatically removes [param object] from the [SceneTree].
func return_object(object: Object) -> void:
	assert(is_instance_valid(object))
	_reset.call(object)
	_free_objects.push_back(object)


## Calls [method Object.free] on every object in the pool. [br]
## [b]Note[/b]: Not called automatically.
func free_object_pool() -> void:
	for object in _objects:
		if is_instance_valid(object) && !(object is RefCounted):
			object.free()
