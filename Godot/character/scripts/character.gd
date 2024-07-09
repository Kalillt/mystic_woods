extends CharacterBody2D

var _state_machine

@export_category("Variables") #para poder declarar variaveis globais
@export var _move_speed: float = 64.0
#os valores abaixo impedem que o personagem pare de forma instantanea, tera um meio termo, sao valores que 
#variam entre 0 e 1
@export var _friction: float = 0.2 #desaceleracao, quanto mais proximo de 1, mais rapido
@export var _acceleration: float = 0.2 #aceleracao

@export_category("Objects")
@export var _animation_tree: AnimationTree = null

func _ready() -> void:
	_state_machine = _animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void: #metodo main
	_move()
	_animate()
	move_and_slide()
	
func _move() -> void:
	var _direction: Vector2 = Vector2( #vetor de duas dimensoes
		Input.get_axis("move_left", "move_right"), #acao negativa e acao positiva dentro desse vetor
		Input.get_axis("move_up", "move_down") #get_axis() pega valor escrito
	)
	
	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction #muda animacao dependendo da posicao
		_animation_tree["parameters/walk/blend_position"] = _direction
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration) #lerp -> interpolacao linear
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration) #terceiro parametro eh o peso, no caso, aceleracao
		return
		
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction) #lerp -> interpolacao linear
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)
	
func _animate() -> void:
	if velocity.length() > 2: #quanto maior esse valor, mais rapida a transicao da animacao andando para parado, e vice-versa
		_state_machine.travel("walk")
		return
		
	_state_machine.travel("idle")
