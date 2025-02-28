extends Node3D

var amb1 = preload("res://escenas/mapas/env_3.tres")
var amb2 = preload("res://escenas/mapas/env_1.tres")
var amb3 = preload("res://escenas/mapas/env_2.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("tutorial"):
		if Opciones.tuto:
			Opciones.tuto=false
			$CanvasLayer3.hide()
		else:
			Opciones.tuto=true
			$CanvasLayer3.show()
	else:
		if Input.is_action_just_pressed("Primera_cam"):
			Opciones.cam=1
		if Input.is_action_just_pressed("Segunda_cam"):
			Opciones.cam=2
		if Input.is_action_just_pressed("toggle_salto"):
			Opciones.toggle_salto+=1
			if Opciones.toggle_salto==2:
				Opciones.toggle_salto=0
		if Input.is_action_just_pressed("dia"):
			Opciones.dia=true
			Opciones.tarde=false
			Opciones.noche=false
			$WorldEnvironment/DirectionalLight3D.light_energy=0.4
			$WorldEnvironment.environment= amb1
		if Input.is_action_just_pressed("tarde"):
			Opciones.dia=false
			Opciones.tarde=true
			Opciones.noche=false
			$WorldEnvironment/DirectionalLight3D.light_energy=0.3
			$WorldEnvironment.environment= amb2
		if Input.is_action_just_pressed("noche"):
			Opciones.dia=false
			Opciones.tarde=false
			Opciones.noche=true
			$WorldEnvironment/DirectionalLight3D.light_energy=0.2
			$WorldEnvironment.environment= amb3
		if Input.is_action_just_pressed("vignet"):
			if $CanvasLayer2.visible:
				$CanvasLayer2.hide()
			else:
				$CanvasLayer2.show()
		if Input.is_action_just_pressed("crt"):
			if $CanvasLayer.visible:
				$CanvasLayer.hide()
			else:
				$CanvasLayer.show()
	pass
