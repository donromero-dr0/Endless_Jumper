extends Control

@onready var game_over_rect: ColorRect = $GameOverRect
@onready var score_label: Label = $MC/ScoreLabel
@onready var high_score_label: Label = $MC/HighScoreLabel


func _enter_tree() -> void:
	get_tree().paused = false


func _ready() -> void:
	SignalHub.game_over.connect(_on_game_over)
	SignalHub.new_height.connect(_on_new_height)
	ScoreManager.high_score_updated.connect(_on_high_score_updated)
	_update_high_score_display(ScoreManager.high_score)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _on_new_height(height: int) -> void:
	score_label.text = "%04d" % height


func _on_high_score_updated(new_high: int) -> void:
	_update_high_score_display(new_high)


func _update_high_score_display(val: int) -> void:
	high_score_label.text = "Best: %04d" % val


func _on_game_over() -> void:
	game_over_rect.show()
	get_tree().paused = true
