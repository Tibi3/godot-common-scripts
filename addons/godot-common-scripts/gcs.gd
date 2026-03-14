## Utility functions and constants
class_name GCS

static var _tree := Engine.get_main_loop() as SceneTree

const I64_MAX := 9_223_372_036_854_775_807
const I64_MIN := -9_223_372_036_854_775_808

const HALF_PI := PI / 2.0
const LOG10 := log(10)

#region Math Utils

## Base 10 logarithm
static func log10(value: float) -> float:
	return log(value) / LOG10


## Returns [code]true[/code] if [param ms] happend less than [param e] ms ago. [br]
## [codeblock] if GCS.lately_ms(jump_pressed_at_ms, 100):
##		jump() [/codeblock]
static func lately_ms(ms: int, e: int) -> bool:
	return Time.get_ticks_msec() - ms <= e


## Same as [method lately_ms] just with microseconds.
static func lately_us(us: int, e: int) -> bool:
	return Time.get_ticks_usec() - us <= e


## Formats microseconds to a human readable string.
static func us_to_human(usec: int) -> String:
	if usec < 1_000:
		return "%dus" % usec
	elif usec < 1_000_000:
		return "%.2fms" % (usec / 1_000.0)

	return "%.2fs" % (usec / 1_000_000.0)


#endregion

#region Node Utils

## Waits [param seconds].[br]
## Only exists because I always forgot to add [code].timeout[/code] after [code]get_tree().create_timer()[/code][br]
## [b]NOTE[/b]: [param process_always] is [code]false[/code] by default.
static func wait_async(seconds: float, process_always := false, ignore_time_scale := false, process_in_physics := false) -> Signal:
	return _tree.create_timer(seconds, process_always, ignore_time_scale, process_in_physics).timeout


## Scans all children (not grandchildren) of [param node] and returns the first node that is type of [param component].
## Use like this:
## [codeblock] @onready var health_component := GCS.get_component_of(entity, HealthComponent) as HealthComponent [/codeblock]
## Works with native types too.
## [codeblock] @onready var nav_agent := GCS.get_component_of(entity, NavigationAgent2D) as NavigationAgent2D [/codeblock]
## if [param include_assert] is [code]true[/code]. It will throw an error if the component is not found.[br]
## [b]Note[/b]: Only throws error in the Editor.[br]
## [b]Note[/b]: This function is O(n) but in usually n is small.
static func get_component_of(entity: Node, component: Variant, include_assert := true) -> Node:
	for child in entity.get_children():
		if is_instance_of(child, component):
			return child

	assert(!include_assert, "Component '%s' not found on entity '%s'" % [component, entity])
	return null


## Calls [method Node.queue_free] on the children of [param node].
static func clear_children(node: Node, include_internal := false) -> void:
	for child in node.get_children(include_internal):
		child.queue_free()


## Instead of writing this every time:
## [codeblock]
## if is_instance_valid(_button_tween):
##	_button_tween.kill()
##
## _button_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
## _button_tween.tween_property(...)
##[/codeblock]
## You can do this:
## [codeblock]
## _button_tween = GCS.reuse_tween(_button_tween, Tween.EASE_IN_OUT, Tween.TRANS_CUBIC)
## _button_tween.tween_property(...)
##[/codeblock]
static func reuse_tween(p_tween: Tween, p_ease := Tween.EaseType.EASE_IN_OUT, p_trans := Tween.TransitionType.TRANS_LINEAR) -> Tween:
	if is_instance_valid(p_tween):
		p_tween.kill()

	return _tree.create_tween().set_ease(p_ease).set_trans(p_trans)


## Loads a resource from [member path].[br]
## Calls [member progress_callback] on every frame with the progress
## (value between [code]0[/code] and [code]1[/code]).[br]
## See [method ResourceLoader.load_threaded_request] for the rest of the args.
## [codeblock]
## # The second param is optional, but it's nice to update the ui or something.
## var result := await GCS.load_async("res://path/to/my_large_level.tscn", func(progress):
##		GCS_Log.info(progress))
## if result.ok():
##	GCS_Log.info("Resource loaded successfully: %s" % result.resource)
## else:
##	GCS_Log.info("Failed to load resource... Error: %s" % error_string(result.status))
## [/codeblock]
static func load_async(path: String,
		progress_callback := func (_progress: float): pass,
		type_hint := "",
		use_sub_threads := false,
		cache_mode := ResourceLoader.CacheMode.CACHE_MODE_REUSE
) -> LoadAsyncResult:
	var res := ResourceLoader.load_threaded_request(path, type_hint, use_sub_threads, cache_mode)

	if res != OK:
		return LoadAsyncResult.new(res, null)

	var progress: Array
	var status: ResourceLoader.ThreadLoadStatus

	status = ResourceLoader.load_threaded_get_status(path, progress)
	progress_callback.call(progress[0])

	while status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await _tree.process_frame
		status = ResourceLoader.load_threaded_get_status(path, progress)
		progress_callback.call(progress[0])

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		return LoadAsyncResult.new(OK, ResourceLoader.load_threaded_get(path))

	return LoadAsyncResult.new(FAILED, null)


## Binds the callable to itself. Useful when you want to disconnect from a signal inside the callable.
## [codeblock]
## # Kinda stupid example :(
## var counter := [5]
## get_tree().process_frame.connect(GCS.lambda(func (this: Callable):
## 			counter[0] -= 1
## 			GCS_Log.info(counter)
## 			if counter[0] <= 0:
## 				get_tree().process_frame.disconnect(this)))
## [/codeblock]
## Prints:[br]  [4][br]  [3][br]  [2][br]  [1][br]  [0]
static func lambda(callable: Callable) -> Callable:
	return callable.bind(callable)

#endregion

#region Log

## Creates an instance of [GCSStopwatch].
## [codeblock]
## var sw := GCS.sw()
## await GCS.wait_async(2.0)
## sw.stop("Elapsed time: %s.")
## [/codeblock]
static func sw(autostart := true) -> GCSStopwatch:
	return GCSStopwatch.new(autostart)


## Same as [method GCS_Log.debug]
static func debug(msg: Variant) -> void:
	GCS_Log.debug(msg, 1)


## Same as [method GCS_Log.info]
static func info(msg: Variant) -> void:
	GCS_Log.info(msg, 1)


## Same as [method GCS_Log.warn]
static func warn(msg: Variant) -> void:
	GCS_Log.warn(msg, 1)


## Same as [method GCS_Log.err]
static func err(msg: Variant) -> void:
	GCS_Log.err(msg, 1)

#endregion

## A wrapper around the loaded resource.
class LoadAsyncResult:
	## [constant OK] if loaded successfully.
	var status: Error
	## The loaded resource. [code]null[/code] if an error happend.
	var resource: Resource

	func _init(p_status: Error, p_resource: Resource) -> void:
		status = p_status
		resource = p_resource


	## Returns [code]true[/code] if the resource was loaded successfully.
	func ok() -> bool:
		return status == OK && is_instance_valid(resource)


	## Calls [method PackedScene.instantiate] on the loaded resource.[br]
	## [b]Note[/b]: Only works if the loaded resource is a [PackedScene]
	func instantiate() -> Node:
		assert(resource is PackedScene)
		return (resource as PackedScene).instantiate()


	func _to_string() -> String:
		return "{%s, %s}" % [error_string(status), resource]
