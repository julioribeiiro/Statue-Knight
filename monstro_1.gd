extends StaticBody2D


var tocou = 0
var tocou_1 = 0
var life = 1
var monstro_morreu = false
var attack = 1
var atacando = false

var ataques_para_vulneravel = 3
var fica_vulneravel = false


const ATACANDO_TEMPO = 0.1
var atacando_delay = 0

const DELAY_1 = 0.5
var time_delay_1 = 0

var time_delay_pisca_1 = 0.3
var time_delay_pisca_1_inst = 0

const DELAY_2 = 0.5
var time_delay_2 = 0

var time_delay_pisca_2 = 0.3
var time_delay_pisca_2_inst = 0

const DELAY_3 = 0.5
var time_delay_3 = 0

var time_delay_pisca_3 = 0.2
var time_delay_pisca_3_inst = 0

const DELAY_4 = 0.3
var time_delay_4 = 0

var time_delay_pisca_4 = 0.2
var time_delay_pisca_4_inst = 0

const DELAY_5 = 0.3
var time_delay_5 = 0

var time_delay_pisca_5 = 0.2
var time_delay_pisca_5_inst = 0

const DELAY_6 = 0.9
var time_delay_6 = 0

var time_delay_pisca_6 = 0.2
var time_delay_pisca_6_inst = 0

var inicio_combate = false

func _ready():
	$"area_ataque/hitbox_ataque".disabled = true
	$"atordoado".hide()


func _process(delta):
#--------------- ATAQUE 1 MONSTRO --------------------------
	if inicio_combate == true and !fica_vulneravel and attack == 1 and !atacando:
		$"area_ataque/hitbox_ataque".disabled = true
		$"monstro".frame = 0
		$"atordoado".hide()
		time_delay_1 += delta
		if time_delay_1 >= DELAY_1:
			$"area_ataque/hitbox_ataque".disabled = true
			$"monstro".frame = 5
			if !$"vermelho_sound".playing and tocou == 0:
				$"vermelho_sound".play()
				tocou += 1
			time_delay_pisca_1_inst += delta
			time_delay_2 += delta
			if time_delay_pisca_1_inst >= time_delay_pisca_1:
				 $"monstro".frame = 1
			#comeca animacao delay_2
			if time_delay_2 >= DELAY_2:
				if !$"vermelho_sound".playing and tocou_1 == 0:
					$"vermelho_sound".play()
					tocou_1 += 1
				$"monstro".frame = 5
				time_delay_pisca_2_inst += delta
				time_delay_3 += delta
				if time_delay_pisca_2_inst >= time_delay_pisca_2:
					$"monstro".frame = 1
				#comeca animacao delay_3
				if time_delay_3 >= DELAY_3:
					$"monstro".frame = 6
					$"area_ataque/hitbox_ataque".disabled = false
					#$"anim".play("ataque")
					tocou = 0
					tocou_1 = 0
					time_delay_1 = 0
					time_delay_2 = 0
					time_delay_3 = 0
					time_delay_pisca_4_inst = 0
					time_delay_pisca_5_inst = 0
					time_delay_pisca_6_inst = 0
					attack = 2
					atacando = true
					

	if atacando:
		atacando_delay += delta
		if atacando_delay >= ATACANDO_TEMPO:
			atacando = false
			atacando_delay = 0

#------------ ATAQUE 2 MONSTRO ---------------------------

	if inicio_combate == true and !fica_vulneravel and attack == 2 and !atacando:
		$"area_ataque/hitbox_ataque".disabled = true
		$"monstro".frame = 0
		time_delay_4 += delta
		if time_delay_4 >= DELAY_1:
			$"area_ataque/hitbox_ataque".disabled = true
			$"monstro".frame = 4
			if !$"roxo_sound".playing and tocou == 0:
				$"roxo_sound".play()
				tocou += 1
			time_delay_pisca_4_inst += delta
			time_delay_5 += delta
			if time_delay_pisca_4_inst >= time_delay_pisca_4:
				 $"monstro".frame = 1
			#comeca animacao delay_2
			if time_delay_5 >= DELAY_5:
				$"monstro".frame = 4
				if !$"roxo_sound".playing and tocou_1 == 0:
					$"roxo_sound".play()
					tocou_1 += 1
				time_delay_pisca_5_inst += delta
				time_delay_6 += delta
				if time_delay_pisca_5_inst >= time_delay_pisca_5:
					$"monstro".frame = 1
				#comeca animacao delay_3
				if time_delay_6 >= DELAY_6:
					$"monstro".frame = 7
					$"area_ataque/hitbox_ataque".disabled = false
					tocou = 0
					tocou_1 = 0
					time_delay_1 = 0
					time_delay_2 = 0
					time_delay_3 = 0
					time_delay_pisca_1_inst = 0
					time_delay_pisca_2_inst = 0
					time_delay_pisca_3_inst = 0
					time_delay_4 = 0
					time_delay_5 = 0
					time_delay_6 = 0
					time_delay_pisca_4_inst = 0
					time_delay_pisca_5_inst = 0
					time_delay_pisca_6_inst = 0
					attack = 1
					atacando = true


	if fica_vulneravel == true:
		$"monstro".frame = 3
		$"atordoado".show()
		$"area_ataque/hitbox_ataque".disabled = true
		$"area_ataque/hitbox_recebe".disabled = false
		
	
func inicia_o_combate():
	inicio_combate = true

func toma_dano():
	ataques_para_vulneravel -= 1
	if ataques_para_vulneravel == 0:
		fica_vulneravel = true
		ataques_para_vulneravel = 3

func toma_hit():
	life -= 1
	print("vida monstro: "+str(life))
	$"area_ataque/hitbox_ataque".disabled = false
	$"area_ataque/hitbox_recebe".disabled = true
	fica_vulneravel = false
	if life == 0:
		monstro_morreu = true
		$"anim".play("morre")

func monstro_morre():
	queue_free()
	

