extends CharacterBody3D


const SPEED = 2


const JUMP_VELOCITY = 4.5

const SENSIVITY = 0.005

const BOB_FREQ = 3

const BOB_AMP = 0.02

var t_bob = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction = ($Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)	
	
	move_and_slide()
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	
	$Head/Camera3D.transform.origin = _headbob()
	
func _input(event):
	if event is InputEventMouseMotion:
		$Head.rotate_y(-event.relative.x * SENSIVITY)
		$Head/Camera3D.rotate_x(-event.relative.y * SENSIVITY)
		$Head/Camera3D.rotation.x = clamp($Head/Camera3D.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
func _headbob() -> Vector3:
	var pos = Vector3.ZERO
	
	pos.y = sin(t_bob * BOB_FREQ) * BOB_AMP
	
	return pos
