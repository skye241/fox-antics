extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var h_box_hearts: HBoxContainer = $MarginContainer/HBoxHearts

var _score: int = 0
var _hearts: Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_score  = GameManager.cached_score
	_hearts = h_box_hearts.get_children()
	on_scored(0)# Replace with function body.



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"): 
		GameManager.load_main()

func _enter_tree() -> void:
	SignalHub.on_scored.connect(on_scored)
	SignalHub.on_player_hit.connect(on_player_hit)

func _exit_tree() -> void:
	GameManager.try_add_new_score(_score)
	

func on_scored(points: int) -> void:
	_score += points
	score_label.text = "%05d" % _score

func on_player_hit(lives:int, shake: bool) -> void:
	for index in range(_hearts.size()):
		_hearts[index].visible = lives > index
		
	if lives <= 0:
		level_over(false)

func level_over(complete: bool) -> void:
	get_tree().paused = true


func _on_complete_timer_timeout() -> void:
	pass # Replace with function body.
