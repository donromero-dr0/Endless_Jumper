class_name Platform
extends Node3D

# --- Inspector Configuration ---
@export_group("Timing")
@export var base_wait_time: float = 4.0
@export var min_time_variance: float = 0.75
@export var max_time_variance: float = 1.2

@export_group("Animation")
@export var vanish_animation_name: StringName = &"vanish"

# --- Child Nodes ---
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var area_3d: Area3D = $Area3D

# --- Internal State ---
var _is_triggered: bool = false


# Detects when the player steps onto the platform
func _on_area_3d_body_entered(body: Node3D) -> void:
	if _is_triggered or not (body is Player):
		return

	_trigger_platform()


func _on_timer_timeout() -> void:
	animation_player.play(vanish_animation_name)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == vanish_animation_name:
		queue_free()


# Activates the platform, disables detection, starts randomized timer, and requests next platform
func _trigger_platform() -> void:
	_is_triggered = true
	area_3d.set_deferred("monitoring", false)

	var wait_duration: float = base_wait_time * randf_range(min_time_variance, max_time_variance)
	timer.start(wait_duration)
	
	SignalHub.emit_new_platform(global_position)
