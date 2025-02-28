extends Camera3D

@export var zoom_sensitivity: float = 0.5  # Sensibilidad del zoom
@export var min_distance: float = 2.0      # Distancia mínima de la cámara
@export var max_distance: float = 10.0     # Distancia máxima de la cámara

# Referencia al nodo de anclaje (Utilidad)
@onready var anchor_node: Node3D = get_parent()
@onready var camera_distance: float = global_transform.origin.distance_to(anchor_node.global_transform.origin)
@onready var character: CharacterBody3D = anchor_node.get_parent()


var initial_camera_distance: float
var initial_camera_position: Vector3
var initial_camera_rotation: Vector3

func _ready():
	# Inicialmente, el mouse no está capturado
	initial_camera_distance = camera_distance
	initial_camera_position = position
	initial_camera_rotation = rotation

	
func _input(event):
	if current:
	# Zoom con la rueda del mouse
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera_distance = clamp(camera_distance - zoom_sensitivity, min_distance, max_distance)
				update_camera_transform()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera_distance = clamp(camera_distance + zoom_sensitivity, min_distance, max_distance)
				update_camera_transform()

func update_camera_transform():
	# Obtener dirección desde la cámara al nodo de anclaje
	var direction = (global_transform.origin - anchor_node.global_transform.origin).normalized()
	
	# Calcular nueva posición con la distancia ajustada
	global_transform.origin = anchor_node.global_transform.origin + direction * camera_distance
