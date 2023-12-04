extends Control
@onready var life_counter = $container/life/counter2
@onready var timer_counter = $container/timer/counter
@onready var score_counter = $container/score/counter
@onready var coins_counter = $container/coins/counter
@onready var timer = $container/Timer

var minutes =0
var seconds = 0

signal time_is_up()

@export_range(0,5) var default_minutes := 1
@export_range(0,59) var default_seconds := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	timer_counter.text = str("%02d" % default_minutes) + ":" + str("%02d" %default_seconds)
	reset_clock()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")


func _on_timer_timeout():
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
	
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)

func reset_clock():
	minutes = default_minutes
	seconds = default_seconds
