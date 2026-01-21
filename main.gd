extends Node2D

@export var mob_scene: PackedScene # Arraste o mob.tscn para cá no Inspector
var score = 0

func _ready():
	pass

# Quando o jogador morre
func _on_player_hit():
	$MobTimer.stop()
	$ScoreTimer.stop()
	$HUD.show_game_over()
	
	# Para a música quando morre
	$Music.stop()

# Inicia um novo jogo
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	
	# Reseta o jogador na posição do Marker2D
	$Player.start($StartPosition.position)
	
	# Liga os cronômetros
	$MobTimer.start()
	$ScoreTimer.start()
	
	# --- A CORREÇÃO ESTÁ AQUI ---
	# Agora a música começa junto com o jogo!
	$Music.play()

# Cria os meteoros
func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	# --- AJUSTE DE MARGEM ---
	# Margem para o meteoro não nascer cortado na parede
	var margin = 50 
	var screen_width = 480 # A largura da sua tela
	
	# Escolhe posição aleatória respeitando a margem (50 a 430)
	var random_x = randf_range(margin, screen_width - margin)
	
	mob.position = Vector2(random_x, -50)
	
	# Velocidade de queda
	mob.linear_velocity = Vector2(0, randf_range(150, 250))
	
	add_child(mob)

# Conta os pontos a cada segundo
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

# Conexão com o sinal do botão Start do HUD
func _on_hud_start_game():
	new_game()
