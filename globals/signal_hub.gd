extends Node


signal new_platform(platform_pos: Vector3)
signal game_over
signal new_height(height: int)

func emit_new_platform(platform_pos: Vector3) -> void:
	new_platform.emit(platform_pos)


func emit_game_over() -> void:
	game_over.emit()


func emit_new_height(height: int) -> void:
	new_height.emit(height)
