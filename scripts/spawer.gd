extends Node2D

@export var inimigo_scene: PackedScene
@export var max_inimigos = 10


func _on_timer_timeout():
	if get_child_count() >= max_inimigos:
		return

	var inimigo = inimigo_scene.instantiate()

	# posição aleatória
	var x = randf() * 800
	var y = randf() * 600
	inimigo.global_position = Vector2(x, y)
	add_child(inimigo)
