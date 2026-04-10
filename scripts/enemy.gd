extends CharacterBody2D

@export var speed = 100
var vida = 30
var player
var vivo = true

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _process(delta):
	if player:
		look_at(player.global_position)
		var direcao = player.global_position - global_position
		velocity = direcao.normalized() * speed
		animation()
		move_and_slide()

func animation():
	if velocity != Vector2.ZERO && vida > 0:
		$AnimationPlayer.play("walk")
	
	if !vivo:
		$AnimationPlayer.play("die")
		morrer()
	
		
func _on_area_2d_body_entered(body):
	pass # Replace with function body.

func tomar_dano(valor):
	vida -= valor
	if vida <= 0:
		vivo = false

func morrer():
	dar_pontos()
	await get_tree().create_timer(0.5).timeout
	queue_free()

func dar_pontos():
	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.adicionar_pontos(10)

func causar_dano():
	return 10
