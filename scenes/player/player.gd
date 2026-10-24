class_name Player
extends CharacterBody3D

# --- Movement Settings ---
@export_group("Movement")
@export var jump_force: float = 30.0
@export var gravity: float = 60.0
@export var ROTATION_SPEED: float = 4.0
@export var MOVE_SPEED: float = 3.5

# --- Shadow Settings ---
@export_group("Drop Shadow")
@export var shadow_base_size: Vector2 = Vector2(2.0, 2.0)
@export var shadow_projection_depth: float = 2.0
@export var shadow_min_scale: float = 0.35
@export var shadow_max_distance: float = 20.0
@export var shadow_fade_with_distance: bool = true
@export var shadow_min_alpha: float = 0.3

# --- Node References ---
@onready var shadow_ray: RayCast3D = $RayCast3D
@onready var shadow_decal: Decal = $ShadowDecal
@onready var animation_player: AnimationPlayer = $"character-female-a2/AnimationPlayer"


func _process(_delta: float) -> void:
	update_drop_shadow()


func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement()
	handle_rotation(delta)
	move_and_slide()
	handle_animation()

func handle_animation() -> void:
	if velocity.y > 0:
		animation_player.play("jump")
	else:
		animation_player.play("fall")

# --- Physics / Movement ---
func handle_gravity(delta: float) -> void:
	velocity.y -= gravity * delta
	if is_on_floor():
		velocity.y = jump_force
		
func handle_rotation(delta: float) -> void:
	if Input.is_action_pressed("left"):
		rotate_y(ROTATION_SPEED * delta)
	if Input.is_action_pressed("right"):
		rotate_y(-ROTATION_SPEED * delta)
		
func handle_movement() -> void:
	var forward: Vector3 = transform.basis.z * Input.get_action_strength("forward")
	velocity.x = forward.x * MOVE_SPEED
	velocity.z = forward.z * MOVE_SPEED

# --- Drop Shadow System ---
func update_drop_shadow() -> void:
	if not shadow_ray.is_colliding():
		shadow_decal.visible = false
		return

	shadow_decal.visible = true
	var hit_point: Vector3 = shadow_ray.get_collision_point()
	shadow_decal.global_position = hit_point

	# Calculate distance and interpolation factor [0.0 (ground) -> 1.0 (max height)]
	var distance: float = maxf(0.0, global_position.y - hit_point.y)
	var t: float = clampf(distance / shadow_max_distance, 0.0, 1.0)
	var scale_factor: float = lerpf(1.0, shadow_min_scale, t)

	# Update decal dimensions (X and Z define circle diameter, Y is projection depth)
	shadow_decal.size = Vector3(
		shadow_base_size.x * scale_factor,
		shadow_projection_depth,
		shadow_base_size.y * scale_factor
	)

	# Optionally fade transparency with height
	if shadow_fade_with_distance:
		shadow_decal.modulate.a = lerpf(1.0, shadow_min_alpha, t)
