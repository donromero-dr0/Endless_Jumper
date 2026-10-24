extends Camera3D

# Camera offset relative to platform and transition travel duration
@export var buffer: Vector3 = Vector3(0, 10, 8)
@export var transition_duration: float = 1.0

var _camera_tween: Tween


func _ready() -> void:
	SignalHub.new_platform.connect(_on_new_platform)


func _on_new_platform(platform_pos: Vector3) -> void:
	var target_pos: Vector3 = platform_pos + buffer

	# Cancel ongoing tween if the player triggers platforms rapidly
	if _camera_tween and _camera_tween.is_valid():
		_camera_tween.kill()

	_camera_tween = create_tween()
	_camera_tween.set_trans(Tween.TRANS_CUBIC)
	_camera_tween.set_ease(Tween.EASE_OUT)
	_camera_tween.tween_property(self, "global_position", target_pos, transition_duration)
