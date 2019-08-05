extends Node

var record = 0
var record_temp = 0
var monstro_morreu = false
var n = 2
var once = false
var timer = 0
const TIMER_FINISHED = 3


func _process(delta):
	if once:
		timer += delta
		if timer >= TIMER_FINISHED:
			once = false
			timer = 0
	
	if $"knight".atacando and !once:
		var new_monster = load("res://monstro_1.tscn").instance()
		add_child(new_monster)
		new_monster.position.x = 128 + 1890*n
		new_monster.position.y = 760
		n += 1
		if $"knight".record > record:
			record = $"knight".record
		once = true
		print(n)
	if n == 8:
		n = 1