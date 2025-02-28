extends Camera3D

# Variables para controlar la sensibilidad del mouse y la distancia de la cámara
@export var mouse_sensitivity: float = 0.002
@export var camera_distance: float = 5.0
@export var zoom_sensitivity: float = 0.5  # Sensibilidad del zoom
@export var min_distance: float = 2.0     # Distancia mínima de la cámara
@export var max_distance: float = 10.0    # Distancia máxima de la cámara

# Variables para almacenar la rotación de la cámara
var yaw: float = 0.0
var pitch: float = 0.0

# Referencia al nodo de anclaje (Utilidad)
@onready var anchor_node: Node3D = get_parent()

# Referencia al personaje (Prueba)
@onready var character: CharacterBody3D = anchor_node.get_parent()



var initial_camera_distance: float
var initial_camera_position: Vector3
var initial_camera_rotation: Vector3
var initial_yaw:float
var initial_pitch:float
# Variable para controlar si el movimiento de la cámara está activo
var is_camera_moving: bool = false

func _ready():
	# Inicialmente, el mouse no está capturado
	initial_camera_distance = camera_distance
	initial_camera_position = position
	initial_camera_rotation = rotation
	initial_yaw = yaw
	initial_pitch = pitch
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	# Activar/desactivar el movimiento de la cámara al hacer clic derecho
	if current:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.pressed:
					# Capturar el mouse y activar el movimiento de la cámara
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					is_camera_moving = true
				else:
					# Liberar el mouse y desactivar el movimiento de la cámara
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					is_camera_moving = false

		# Mover la cámara solo si está activo el movimiento
		if is_camera_moving and event is InputEventMouseMotion:
			# Obtener el movimiento del mouse
			var mouse_delta = event.relative

			# Aplicar la sensibilidad del mouse
			yaw -= mouse_delta.x * mouse_sensitivity
			pitch -= mouse_delta.y * mouse_sensitivity

			# Limitar el ángulo de pitch para evitar giros extraños
			pitch = clamp(pitch, -PI / 2, PI / 2)

			# Actualizar la posición de la cámara y la rotación del personaje
			update_camera_transform()
			update_character_rotation()

		# Zoom con la rueda del mouse
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera_distance = clamp(camera_distance - zoom_sensitivity, min_distance, max_distance)
				update_camera_transform()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera_distance = clamp(camera_distance + zoom_sensitivity, min_distance, max_distance)
				update_camera_transform()

func update_camera_transform():
	# Calcular la nueva posición de la cámara basada en la rotación
	var rotations = Quaternion(Vector3.UP, yaw) * Quaternion(Vector3.RIGHT, pitch)
	var offset = rotations * Vector3(0, 0, camera_distance)

	# Actualizar la posición y rotación de la cámara
	global_transform.origin = anchor_node.global_transform.origin + offset
	look_at(anchor_node.global_transform.origin, Vector3.UP)

func update_character_rotation():
	# Actualizar la rotación del personaje (Prueba) en el eje Y
	character.rotation.y = yaw
