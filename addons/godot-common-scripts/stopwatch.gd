## A simple Stopwatch
##
## Use it to measure time. [br]
## See also [method GCS.sw].
class_name GCSStopwatch

var _started_at_us: int

func _init(autostart: bool) -> void:
	if autostart:
		start()


func start() -> void:
	_started_at_us = Time.get_ticks_usec()

## Returns how much time elapsed in microseconds.[br]
## if [param format] is not empty. Prints the elapsed time. [br]
## [b]Note[/b]: the format string has to contain exactly one [code]"%s"[/code].[br]
## [b]Note[/b]: [member GCS_Log.level] has to be [constant GCS_Log.Level.INFO] or lower
## or nothing will be printed.
func stop(format := "Took %s.") -> int:
	var took_us := Time.get_ticks_usec() - _started_at_us

	if !format.is_empty():
		GCS_Log.info(format % GCS.us_to_human(took_us), 1)

	return took_us
