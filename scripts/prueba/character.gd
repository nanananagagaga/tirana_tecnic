extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5
var lag_frame= 0.2
var tiempo =0 
var rota= 0.05
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var idle = load("res://assets/sprites/personajes/prueba/64X128_Idle_Free.png")
var walk = load("res://assets/sprites/personajes/prueba/64X128_Runing_Free.png")
var utilidad_pos_inicial = Vector3(0,0,0)
var utilidad_rot_inicial = Vector3(0,0,0)



func _ready() -> void:
	utilidad_pos_inicial = $utilidad.position
	utilidad_rot_inicial = $utilidad.rotation

func rotate_utilidad(degrees):
	var tween = get_tree().create_tween()
	# Tween para la rotación de $utilidad
	rotation.y = rotation.y + deg_to_rad(degrees)
	tween.tween_property($utilidad, "rotation:y", $utilidad.rotation.y + deg_to_rad(degrees), 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _physics_process(delta):
	### AQUI PONEMOS QUE LA SOMBRA SIGA AL PJE PERO NO EN SALTO ###
	
	if Opciones.toggle_salto==0:
		$utilidad.position.x=position.x
		$utilidad.position.z=position.z
	else:
		$utilidad.position.x=position.x
		$utilidad.position.z=position.z
		$utilidad.position.y=position.y+1
	tiempo += delta
	var frame = $Sprite3D.frame
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY
			
	if Opciones.cam==1:
		$utilidad/Cam1.current=true
		$utilidad/Cam2.current=false

	elif Opciones.cam==2:
		$utilidad/Cam2.current=true
		$utilidad/Cam1.current=false
		
	if Input.is_action_just_pressed("ui_esc"):
		# Restaurar la rotación del personaje (Prueba)
		Opciones.cam=1
		rotation.y = deg_to_rad(-180)
		$utilidad.position=utilidad_pos_inicial
		$utilidad.rotation=utilidad_rot_inicial
		$utilidad/Cam1.camera_distance = $utilidad/Cam1.initial_camera_distance
		$utilidad/Cam1.position = $utilidad/Cam1.initial_camera_position
		$utilidad/Cam1.rotation = $utilidad/Cam1.initial_camera_rotation
		$utilidad/Cam2.camera_distance = $utilidad/Cam1.initial_camera_distance
		$utilidad/Cam2.position = $utilidad/Cam1.initial_camera_position
		$utilidad/Cam2.rotation = $utilidad/Cam1.initial_camera_rotation
		$utilidad/Cam2.yaw = $utilidad/Cam2.initial_yaw
		$utilidad/Cam2.pitch = $utilidad/Cam2.initial_pitch
		
	if Input.is_action_just_pressed("L"):
		rotate_utilidad(-30)
	elif Input.is_action_just_pressed("R"):
		rotate_utilidad(30)
			
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up"):
		$Sprite3D.texture = walk
		if Input.is_action_pressed("ui_down"):
			if $Sprite3D.frame_coords.y != 0:
				$Sprite3D.frame_coords.y = 0
		if Input.is_action_pressed("ui_right"):
			if $Sprite3D.frame_coords.y != 2:
				$Sprite3D.frame_coords.y = 2
		if Input.is_action_pressed("ui_left"):
			if $Sprite3D.frame_coords.y != 1:
				$Sprite3D.frame_coords.y = 1
		if Input.is_action_pressed("ui_up"):
			if $Sprite3D.frame_coords.y != 3:
				$Sprite3D.frame_coords.y = 3
	else:
		$Sprite3D.texture = idle
		
	if tiempo > lag_frame:
			if $Sprite3D.frame_coords.x == 0:
				$Sprite3D.frame_coords.x=1
			elif $Sprite3D.frame_coords.x == 1:
				$Sprite3D.frame_coords.x=2
			elif $Sprite3D.frame_coords.x == 2:
				$Sprite3D.frame_coords.x=3
			elif $Sprite3D.frame_coords.x == 3:
				$Sprite3D.frame_coords.x=4
			elif $Sprite3D.frame_coords.x == 4:
				$Sprite3D.frame_coords.x=5
			elif $Sprite3D.frame_coords.x == 5:
				$Sprite3D.frame_coords.x=6
			elif frame == 6:
				$Sprite3D.frame_coords.x=7
			else:
				$Sprite3D.frame_coords.x=0
			tiempo=0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
