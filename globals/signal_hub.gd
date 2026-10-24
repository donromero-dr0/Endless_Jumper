extends Node


signal new_platform(platform_pos: Vector3)

func emit_new_platform(platform_pos: Vector3) -> void:
	new_platform.emit(platform_pos)
