extends Node

signal high_score_updated(new_high_score: int)

const SAVE_PATH: String = "user://sky.cfg"
const SECTION: String = "game"
const VALUE_KEY: String = "high_score"

var high_score: int = 0


func _enter_tree() -> void:
	load_score()


func _ready() -> void:
	SignalHub.new_height.connect(_on_new_height)
	SignalHub.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	save_score()


func _on_new_height(height: int) -> void:
	if height > high_score:
		high_score = height
		high_score_updated.emit(high_score)


func save_score() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value(SECTION, VALUE_KEY, high_score)
	config.save(SAVE_PATH)


func load_score() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		high_score = config.get_value(SECTION, VALUE_KEY, 0)
