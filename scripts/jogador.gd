extends CharacterBody2D
@onready var sprite_2d = $"../end/Sprite2D"


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var direction
var knockback_vector := Vector2.ZERO
@onready var animation := $animacao as AnimatedSprite2D
@onready var remote_transform := $remote
signal player_has_died
@onready var jump = $jump


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump.play()
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	_set_state()
	move_and_slide()


func _on_hurtbox_body_entered(body):
	if $ray_right.is_colliding():
		take_damage(Vector2(-200, -200))
	elif $ray_left.is_colliding():
		take_damage(Vector2(200, -200))

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
		
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
	
func _set_state():
	var state = "idle"
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	if animation.name != state:
		animation.play(state)


func _on_area_2d_body_entered(body):
	queue_free()
	emit_signal("player_has_died")
