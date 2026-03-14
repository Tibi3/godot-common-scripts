# Godot Common Scripts

I noticed I reimplement a lot of stuff when I start a new project, so I uploaded them here.

## Contains

- Finate state machine
- Logger
- Utility functions
- TODO: ingame dev console
- TODO: shader utility

## Examples

```gd
# init logger
GCS_Log.register_handler(GCS_Log.DEFAULT_HANDLERS.DefaultEditorHandler.new())

# Start a Stopwatch to measure loading time.
var sw := GCS.sw()

# Load this scene on multiple threads.
var result := await GCS.load_async("res://path/to/my_large_scene", func(progress: float) -> void:
		# Called every frame
		GCS.info(progress))

if result.ok():
	GCS.info("success")
	var level := result.instantiate() as Level
	add_child(level)
else:
	GCS.warn("Failed to load scene.")

sw.stop("Loading took %s.")

```
