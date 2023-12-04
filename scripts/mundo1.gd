extends Node2D

@onready var player := $jogador
@onready var camera := $camera
@onready var control = $hud/Control

func _ready():
	player.follow_camera(camera)
	player.player_has_died.connect(reload_game)
	control.time_is_up.connect(reload_game)

func reload_game():
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3
