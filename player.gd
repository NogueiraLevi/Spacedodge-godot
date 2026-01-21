extends Area2D

signal hit

@export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide() # Esconde ao iniciar o jogo (esperando o Start)

func start(pos):
	position = pos
	show() # Mostra o jogador
	$CollisionShape2D.disabled = false
	
	# --- FORÇA A ANIMAÇÃO A COMEÇAR AQUI ---
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play() 

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		# Se quiser que pare de animar ao parar, tire o # da linha abaixo:
		# $AnimatedSprite2D.stop()
		pass

	position += velocity * delta
	
	# --- CORREÇÃO 2: AS BORDAS (PADDING) ---
	# Antes era: position.clamp(Vector2.ZERO, screen_size)
	# Agora vamos dizer: "Pare 40 pixels ANTES de chegar no zero ou no fim da tela"
	# Se a nave ainda cortar um pedaço, aumente o 40 para 50 ou 60.
	var padding = 40 
	position = position.clamp(Vector2(padding, padding), screen_size - Vector2(padding, padding))

	# --- CORREÇÃO 1: SEM CAMBALHOTAS ---
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# Mantemos apenas o espelhamento horizontal (olhar pra esquerda/direita)
		$AnimatedSprite2D.flip_h = velocity.x < 0 
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		# Removemos a linha que virava de cabeça para baixo (flip_v)
		# A nave vai continuar "em pé" mesmo descendo.

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
