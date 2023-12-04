extends Area2D
@onready var sfx = $sfx

var coins := 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	$animacao.play("collect")
	await $colisao.call_deferred("queue_free")
	Globals.coins += coins
	sfx.play()
	


func _on_animacao_animation_finished():
	queue_free()
