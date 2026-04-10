extends CharacterBody2D

# ========================
# CONFIG
# ========================
var speed = 100
var vida = 100
var pontos = 0
var rot_speed = 4 # velocidade de rotação
var is_atacking = false

@onready var label_hp = get_parent().get_node("CanvasLayer/LabelHP")
@onready var label_pontos = get_parent().get_node("CanvasLayer/LabelPontos")
@onready var tela_game_over = get_parent().get_node("CanvasLayer/Control")

# inimigos dentro da área de ataque
var inimigos_na_area = []

# ========================
# INICIO
# ========================
func _ready():
	atualizar_hud()

# ========================
# MOVIMENTO (get_axis)
# ========================
func _physics_process(delta):
	var rot_dir = Input.get_axis("ui_left", "ui_right")
	rotation += rot_dir * rot_speed * delta

	var direction = Vector2.RIGHT.rotated(rotation)

# movimento frente / trás
	var move_dir = Input.get_axis("ui_down", "ui_up")
	velocity = direction * move_dir * speed
	
	animation()
	move_and_slide()
	

	
func animation():
	if velocity != Vector2.ZERO && !is_atacking:
		$AnimationPlayer.play("walk")
		return
	if is_atacking:
		$AnimationPlayer.play("atack")
		return
	
	else:
		$AnimationPlayer.play("idle")
		return
		
# ========================
# ATAQUE (CLIQUE)
# ========================
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		is_atacking = true
		atacar()

func atacar():
	if inimigos_na_area.size() > 0:
		var alvo = inimigos_na_area[0] # pega o primeiro inimigo
	
	for inimigo in inimigos_na_area:
		if inimigo.has_method("tomar_dano"):
			inimigo.tomar_dano(10)
	
	await get_tree().create_timer(0.5).timeout
	is_atacking = false
# ========================
# AREA DE ATAQUE
# ========================
func _on_area_ataque_body_entered(body):
	if body.is_in_group("inimigos"):
		inimigos_na_area.append(body)
	print (inimigos_na_area)

func _on_area_ataque_body_exited(body):
	if body in inimigos_na_area:
		inimigos_na_area.erase(body)

# ========================
# RECEBER DANO (CORPO)
# ========================
func _on_area_corpo_body_entered(body):
	if body.has_method("causar_dano"):
		receber_dano(body.causar_dano())

func receber_dano(valor):
	vida -= valor
	atualizar_hud()

	if vida <= 0:
		morrer()

# ========================
# MORTE
# ========================
func morrer():
	print("Game Over")
	tela_game_over.visible = true
	get_tree().paused = true

# ========================
# HUD
# ========================
func atualizar_hud():
	label_hp.text = "Energy: " + str(vida)

func adicionar_pontos(valor):
	pontos += valor
	atualizar_pontos()

func atualizar_pontos():
	label_pontos.text = "Score: " + str(pontos)


func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.
