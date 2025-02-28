extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	environment.sky_rotation.y+=delta*0.01
	$DirectionalLight3D.rotation.y+=delta*0.01
	if Input.is_action_just_pressed("mas"):
		environment.background_energy_multiplier+=0.1
		$DirectionalLight3D.light_energy+=0.1
		environment.sky.sky_material.energy_multiplier+=0.1
	elif Input.is_action_just_pressed("menos"):
		environment.background_energy_multiplier-=0.1
		$DirectionalLight3D.light_energy-=0.1
		environment.sky.sky_material.energy_multiplier-=0.1
	pass
