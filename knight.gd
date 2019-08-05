extends KinematicBody2D


const SPEED_MAX = 300
const ACELERATION = 20

const GANHA_STAMINA = 0.2
const PERDE_STAMINA = 0.035 #PORCENTAGEM 0.1 0.2 ....
const TIME_TO_LOSE_STAMINA = 0.2
const PERDE_STAMINA_DANO = 0.15
var time_atual_lose_stamina = 0


const TIME_TURN = 0.001
var time_atual_turn_stone = 0

var time_tomou_dano = 0

var motion = Vector2()
var game_started = false
var parado = true
var colisao = true
var monstro = null
var pode_hitar = false
var chegou_final = false
var monstro_morreu = false
var time_idle = 0.3
var time_idle_inst = 0
var atacando = false
var morto = false
var delay_reset = null
var tomou_dmg = false
var estatua = false
var score = 0
var record = 0
var vezes_morreu = 0
var som_morte_tocou = false

func _ready():
	$"perdeu".hide()
	$"hit/hitbox_statue".disabled = true
	$"hit/hitbox_ataque".disabled = true
	$"personagem".play("idle")
	$"stamina_fundo".hide()
	$"stamina_verde".hide()
	$"Score".hide()
	$"stamina".hide()
	$"score_fundo".hide()
	$"som_fundo".play()
	
	record = get_parent().record
	
	delay_reset = Timer.new()
	delay_reset.set_one_shot(true)
	delay_reset.set_wait_time(0.6)
	delay_reset.connect("timeout", self, "reseta_ataque")
	add_child(delay_reset)

func reseta_ataque():
	atacando = false
	tomou_dmg = false

func _physics_process(delta):

#--------- VOLTANDO PARA POSICAO IDLE ---------

	time_idle_inst += delta
	if time_idle_inst >= time_idle and !morto and !atacando and !tomou_dmg and parado and !estatua:
		$"personagem".play("idle")
		time_idle_inst = 0
	
	elif morto:
		$"personagem".play("morto")
		$"som_fundo".stop()
		if !som_morte_tocou:
			$"som_morte".play()
			som_morte_tocou = true
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene("res://cenario.tscn")
			get_parent().record_temp = record
	
	elif !game_started:
		$"personagem".play("idle")

	elif time_idle_inst >= time_idle and !morto and !atacando and !tomou_dmg and !parado:
		$"personagem".play("walk")
		time_idle_inst = 0
	

#--------------- INICIANDO O JOGO  -----------------
	if Input.is_action_just_pressed("ui_accept") and !game_started:
		parado = false
		$"press_start".stop()
		$"comecar".hide()
		$"stamina_fundo".show()
		$"stamina_verde".show()
		$"Logo".hide()
		$"Score".show()
		$"stamina".show()
		$"texto_1".hide()
		$"menu_fundo".hide()
		$"score_fundo".show()
		motion.x += ACELERATION
		game_started = true
	
	if game_started == true and motion.x < SPEED_MAX:
		motion.x += ACELERATION

#-------------- ACOES PERSONAGEM --------------------
	if Input.is_action_pressed("ui_accept") and game_started and parado:#CARREGANDO PARA TRANSFORMAR
		time_atual_turn_stone += delta
		motion.x = 0 #RESETA A VELOCIDADE

	
#-------------- ACOES AO SOLTAR O ESPACO ------------------
	elif Input.is_action_just_released("ui_accept"):
		$"hit/hitbox_statue".disabled = true
		$"dano/hitbox_toma_dano".disabled = false
		if time_atual_lose_stamina > 0.03:
			$"stamina_verde".scale.x -= PERDE_STAMINA
		time_atual_turn_stone = 0
		time_atual_lose_stamina = 0
		estatua = false
		
#------------ PERDE ESTAMINA SEGURANDO O ESPACO ---------------
	if time_atual_lose_stamina >= TIME_TO_LOSE_STAMINA:
		$"stamina_verde".scale.x -= PERDE_STAMINA
		time_atual_lose_stamina = 0
	
#------------ TRANSFORMOU EM PEDRA -----------------------
	if estatua:
		time_atual_lose_stamina += delta
		time_atual_turn_stone = 0
		
	elif time_atual_turn_stone >= TIME_TURN:
		$"personagem".play("estatua")
		$"hit/hitbox_statue".disabled = false
		$"dano/hitbox_toma_dano".disabled = true
		estatua = true
		
#----- AJUSTE DE BARRA DE STAMINA -----------------	
	if $"stamina_verde".scale.x < 0:
		$"stamina_verde".scale.x = 0
		$"perdeu".show()
		vezes_morreu += 1
		$"perdeu".text = "Voce perdeu, pressione espaco para recomecar\nVoce morreu: "+str(vezes_morreu)+" vezes"
		$"personagem".play("morto")
		game_started = false
		morto = true
		$"personagem".position.y = 40
	if $"stamina_verde".scale.x > 1:
		$"stamina_verde".scale.x = 1

	colisao = $".".move_and_collide(motion*delta)

#----- PERSONAGEM PODE ATACAR --------------------
	if Input.is_action_just_pressed("ui_accept") and pode_hitar and !tomou_dmg and !morto:
		monstro.toma_hit()
		$"personagem".play("attack")
		$"monstro_morre_sound".play()
		pode_hitar = false
		monstro_morreu = monstro.monstro_morreu #VERIFICA SE MONSTRO MORREU
		atacando = true
		delay_reset.start()

#-------------- VERIFICANDO SE PERSONAGEM ESTA PARADO -------------
	if colisao != null:
		parado = true
		if game_started: 
			monstro = colisao.get_collider()
			monstro.inicia_o_combate()
	else:
		parado = false
	
#-------------- INFINITE RUN ----------------------------
	if position.x > 16280:
		position.x = 128
		chegou_final = true

#------------- GANHA STAMINA QUANDO MATA O MONSTRO ---------
	if parado:
		if monstro_morreu == true:
			$"stamina_verde".scale.x += GANHA_STAMINA
			monstro.monstro_morreu = false
			monstro_morreu = false
			score += 10
			if score < 100:
				$"Score".text = "Score: 0"+str(score)
			else:
				$"Score".text = "Score: "+str(score)
			if score > record:
				record = score

#----- QUANDO ATAQUE EH DEFENDIDO COM SUCESSO ------------
func _on_hit_area_entered(area):
	monstro.toma_dano()
	pode_hitar = monstro.fica_vulneravel
	$"deflect_sound".play()

#----- QUANDO PERSONAGEM TOMA DANO -----------------
func _on_dano_area_entered(area):
	if atacando == false:
		$"hit_sound".play()
		$"personagem".play("recebe_dano")
		tomou_dano()
		$"stamina_verde".scale.x -= PERDE_STAMINA_DANO
		tomou_dmg = true
		delay_reset.start()

func tomou_dano():
	pass
	#PERSONAGEM SE TRANSFORMA EM PEDRA POR UM CURTO INTERVALO DE TEMPO

func pode_atacar():
	pode_hitar = true
	monstro.toma_hit()