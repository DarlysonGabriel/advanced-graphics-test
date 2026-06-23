extends CharacterBody3D

@export var WALK_SPEED := 4.0
@export var RUN_SPEED := 8.0
@export var JUMP_VELOCITY := 4.5
@export var sensibilidade_mouse := 0.3

@onready var pivo_horizontal = $Pivohorizontal
@onready var camera = $Pivohorizontal/Camera3D

#Folego
var folego_atual := 100.0
const FOLEGO_MAX := 100.0
const TAXA_GASTO := 25.0
const TAXA_GANHO := 15.0

#Head-Bob
var bob_tempo := 0.0
const BOB_FREQ_WALK := 0
const BOB_FREQ_RUN := 0
const BOB_AMPLITUDE := 0

var camera_pos_original : Vector3

var _rotacao_input := 0.0
var _inclinacao_input := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_pos_original = camera.position

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_rotacao_input = -event.relative.x * sensibilidade_mouse
		_inclinacao_input = -event.relative.y * sensibilidade_mouse

func _physics_process(delta):

	#Mouse
	rotate_y(deg_to_rad(_rotacao_input))
	pivo_horizontal.rotate_x(deg_to_rad(_inclinacao_input))

	pivo_horizontal.rotation.x = clamp(
		pivo_horizontal.rotation.x,
		deg_to_rad(-80),
		deg_to_rad(80)
	)

	_rotacao_input = 0.0
	_inclinacao_input = 0.0

	#Corrida
	var speed = WALK_SPEED

	folego_atual = clamp(folego_atual, 0.0, FOLEGO_MAX)

	#Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#Movimento
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)

	#Head-Bob-Backrooms
	_head_bob(delta, speed)

	move_and_slide()

func _head_bob(delta, speed):
	var horizontal_speed = Vector2(velocity.x, velocity.z).length()

	if is_on_floor() and horizontal_speed > 0.1:
		var freq = BOB_FREQ_RUN if speed == RUN_SPEED else BOB_FREQ_WALK

		bob_tempo += delta * freq

		camera.position.y = camera_pos_original.y + sin(bob_tempo) * BOB_AMPLITUDE
		camera.position.x = camera_pos_original.x + cos(bob_tempo * 0.5) * (BOB_AMPLITUDE * 0.5)
	else:
		bob_tempo = 0.0
		camera.position = camera.position.lerp(camera_pos_original, delta * 10.0)
