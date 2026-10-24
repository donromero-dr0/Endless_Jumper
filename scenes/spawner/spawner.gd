extends Node

# Offset ranges (min, max distance) for spawning consecutive platforms
const OFFSET_SIDE: Vector2 = Vector2(1.7, 4.0)
const OFFSET_UP: Vector2 = Vector2(2.7, 4.5)

@export var platform_scenes: Array[PackedScene]

@onready var initial_platform: Platform = $Platform


func _ready() -> void:
	# Listen for global platform trigger events
	SignalHub.new_platform.connect(_on_new_platform_requested)


# Picks a random distance in range and randomly flips sign 
func _get_random_offset(offset_range: Vector2) -> float:
	var magnitude: float = randf_range(offset_range.x, offset_range.y)
	return magnitude if randf() < 0.5 else -magnitude


# Spawns a new platform relative to the previous platform's position
func _on_new_platform_requested(old_platform_position: Vector3) -> void:
	if platform_scenes.is_empty():
		return

	var new_platform: Platform = platform_scenes.pick_random().instantiate()
	new_platform.position = old_platform_position + Vector3(
		_get_random_offset(OFFSET_SIDE),
		randf_range(OFFSET_UP.x, OFFSET_UP.y),
		_get_random_offset(OFFSET_SIDE)
	)
	add_child(new_platform)
