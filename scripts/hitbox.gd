extends Area2D
@onready var sfx = $"../sfx"



func _on_body_entered(body):
	if body.name == "jogador":
		body.velocity.y = body.JUMP_VELOCITY
		sfx.play()
		owner.anim.play("hurt")

