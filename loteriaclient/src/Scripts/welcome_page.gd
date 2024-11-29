extends Control

@onready var animation_player1: AnimationPlayer = $Panel/TextureRect/AnimationPlayer
@onready var animation_player2: AnimationPlayer = $Panel/TextureRect2/AnimationPlayer
@onready var animation_player3: AnimationPlayer = $Panel/TextureRect3/AnimationPlayer
@onready var animation_player4: AnimationPlayer = $Panel/TextureRect4/AnimationPlayer
@onready var animation_player5: AnimationPlayer = $Panel/TextureRect5/AnimationPlayer
@onready var animation_player6: AnimationPlayer = $Panel/TextureRect6/AnimationPlayer
@onready var animation_player7: AnimationPlayer = $Panel/TextureRect7/AnimationPlayer

# Array of TextureRect nodes
@onready var texture_rects: Array = [
	$Panel/TextureRect,
	$Panel/TextureRect2,
	$Panel/TextureRect3,
	$Panel/TextureRect4,
	$Panel/TextureRect5,
	$Panel/TextureRect6,
	$Panel/TextureRect7
]

func _ready() -> void:
	play_all_with_delays()

func play_all_with_delays() -> void:
	# Play animations and show TextureRects with delays
	texture_rects[0].visible = true
	animation_player1.play("LetterL")
	await get_tree().create_timer(1).timeout

	texture_rects[1].visible = true
	animation_player2.play("LetterL")
	await get_tree().create_timer(1).timeout

	texture_rects[2].visible = true
	animation_player3.play("LetterL")
	await get_tree().create_timer(1).timeout

	texture_rects[3].visible = true
	animation_player4.play("LetterL")
	await get_tree().create_timer(1).timeout

	texture_rects[4].visible = true
	animation_player5.play("LetterL")
	await get_tree().create_timer(1).timeout

	texture_rects[5].visible = true
	animation_player6.play("LetterL")
	await get_tree().create_timer(1).timeout

	texture_rects[6].visible = true
	animation_player7.play("LetterL")
	await get_tree().create_timer(1.5).timeout
	
	animation_player1.play("LetterL")
	animation_player2.play("LetterL")
	animation_player3.play("LetterL")
	animation_player4.play("LetterL")
	animation_player5.play("LetterL")
	animation_player6.play("LetterL")
	animation_player7.play("LetterL")
