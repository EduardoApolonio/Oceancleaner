extends Node2D

signal inimigo_derrotado(total: int)

@export var cena_inimigo: PackedScene
@export var tamanho_pool: int = 50
@export var tempo_spawn: float = 1.0

@export var jogador: Node2D 

# ✅ CORRIGIDO: Tipamos a Array com a sua classe personalizada 'Inimigo'
var pool_inimigos: Array[Inimigo] = []
var timer_spawn: Timer
var total_derrotados: int = 0

func _ready() -> void:
	_inicializar_pool()
	_configurar_timer()

func _inicializar_pool() -> void:
	if cena_inimigo == null:
		push_error("Arraste o arquivo inimigo.tscn para o Inspetor do Gerenciador!")
		return

	for i in range(tamanho_pool):
		var instancia = cena_inimigo.instantiate()
		
		# Converte para o tipo da sua classe Inimigo
		if instancia is Inimigo:
			var inimigo: Inimigo = instancia
			inimigo.hide()
			inimigo.set_physics_process(false)
			inimigo.died.connect(_on_inimigo_derrotado)
			add_child(inimigo)
			pool_inimigos.append(inimigo)
		else:
			push_error("O nó raiz da cena do inimigo precisa herdar de CharacterBody2D e ter 'class_name Inimigo'")

func _on_inimigo_derrotado() -> void:
	total_derrotados += 1
	inimigo_derrotado.emit(total_derrotados)

func _configurar_timer() -> void:
	timer_spawn = Timer.new()
	timer_spawn.wait_time = tempo_spawn
	timer_spawn.autostart = true
	timer_spawn.timeout.connect(_gerar_inimigo)
	add_child(timer_spawn)

func _gerar_inimigo() -> void:
	if jogador == null:
		return

	for inimigo in pool_inimigos:
		if not inimigo.visible:
			var pos = _obter_posicao_aleatoria_fora_da_tela()
			# Agora o Godot sabe com 100% de certeza que 'inimigo' possui o método renascer()!
			inimigo.renascer(pos, jogador) 
			return

func _obter_posicao_aleatoria_fora_da_tela() -> Vector2:
	var raio = randf_range(500, 700)
	var angulo = randf() * TAU
	return jogador.global_position + Vector2(cos(angulo), sin(angulo)) * raio
