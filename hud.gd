extends CanvasLayer 

# Notifica Main que deu "Start"
signal start_game

# Mensagem temporária (para começar o game)
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
# Mostrar o Game Over
func show_game_over():
	show_message("Game Over")
	# Espera mensagem "sumir"
	await $MessageTimer.timeout
	
	$Message.text = "Space Dodge!"
	$Message.show()
	# Timer temporário para mostrar o botão após
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
# Atualiza o Placar
func update_score(score):
	$ScoreLabel.text = str(score)
	
# Start Pressionado
func on_start_button_pressed():
	$StartButton.hide()
	start_game.emit() # main inicia o jogo
	
# Esconde mensagem após o time dela
func _on_message_timer_timeout():
	$Message.hide()
