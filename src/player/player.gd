extends CharacterBody2D

signal state_changed(previous: States, new: States)

enum States {IDLE, WALKING}

var state: States
var direction := Vector2.ZERO
var last_direction := Vector2(0, 1) # default animation: idle down

@onready var animated_sprite = %AnimatedSprite2D as AnimatedSprite2D

@export var MOVEMENT_SPEED := 200.0

func _ready() -> void:
	change_state(States.IDLE)

func _physics_process(delta: float) -> void:
	last_direction = direction
	
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * MOVEMENT_SPEED
	
	if last_direction != direction:
		# don't change states if the state is the same
		change_state(States.IDLE) if velocity == Vector2.ZERO else change_state(States.WALKING)

	move_and_slide()

func change_state(new_state: States) -> void:
	state_changed.emit(state, new_state)
	state = new_state

func change_animation(direction: Vector2, last_direction: Vector2) -> void:
	# prioritize vertical movement
	if direction.y > 0:
		animated_sprite.play("walk_down")
	elif direction.y < 0:
		animated_sprite.play("walk_up")
	elif direction.x > 0:
		animated_sprite.play("walk_right")
	elif direction.x < 0:
		animated_sprite.play("walk_left")
	else:
		if last_direction.y > 0:
			animated_sprite.play("idle_down")
		elif last_direction.y < 0:
			animated_sprite.play("idle_up")
		elif last_direction.x > 0:
			animated_sprite.play("idle_right")
		elif last_direction.x < 0:
			animated_sprite.play("idle_left")

func _on_state_changed(previous: States, new: States) -> void:
	change_animation(direction, last_direction)
