# Godot Common Scripts

I noticed I reimplement a lot of stuff when I start a new project, so I uploaded them here.

## Contains

- Logger
- ObjectPool
- Finate state machine
- Simplified multithreaded loading + other utility functions
- WIP ingame dev console
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

### ObjectPool
```gd
class_name EnemySpawner
extends Node

const ENEMY_PCK = preload("uid://ewrwg5ilxuny")
const ENEMY2_PCK = preload("uid://ewrwg5ilxunz")

@onready var enemy_pool := GCSMultiNodePool.new()

func _ready() -> void:
	enemy_pool.keep_in_tree = true							# Won't remove from the SceneTree.
	enemy_pool.add_pool(SimpleEnemy, GCSObjectPool.new(		# Can use anything as a key, I like to use the enemy class_name
			5000,											# Store maximum 5000
			func(): 										# Create an Enemy like this
					var enemy := ENEMY_PCK.instantiate()
					add_child(enemy)
					return enemy,
			func(enemy): 									# Reset them like this
					enemy.position.x = 9999
					enemy.process_mode = Node.PROCESS_MODE_DISABLED
					enemy.hide(),
			100))											# Create 100 now. The rest is lazy loaded.

	# We will have a lot of SimpleEnemy2 too.
	enemy_pool.add_pool(SimpleEnemy2, GCSObjectPool.new(...))
	add_child(enemy_pool)


func spawn_enemy() -> void:
	var enemy := enemy_pool.borrow_node(SimpleEnemy) as SimpleEnemy
	enemy.died.connect(func (): enemy_pool.return_node(SimpleEnemy, enemy))
	enemy.position = get_random_spawn_point()
	enemy.process_mode = Node.PROCESS_MODE_INHERIT
	enemy.show()
```
