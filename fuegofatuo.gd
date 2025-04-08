extends CharacterBody2D

var speed = 200 
var player_chase = false
var player = null
var arma_en_enemigo = false
var health = 3
var player_attack_area = false
var cooldown_enemigo = true
var atacando = false

@onready var barra_vida = $barra_vida_sombra

func fuegofatuo():
	pass

func _physics_process(delta):
	barra_vida.value = health
	get_damaged()
	
	if health <= 0:
		if $AnimatedSprite2D.animation != "muerte":  
			$AnimatedSprite2D.play("muerte")  
		speed = 0
		player_chase = false
		cooldown_enemigo = false
		player_attack_area = false
		atacando = false
		$hitbox_sombra.set_deferred("monitorable", false)
		$hitbox_sombra.set_deferred("monitoring", false)
		await get_tree().create_timer(0.5).timeout
		self.queue_free()

	if player_chase and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed  
		$AnimatedSprite2D.play ("movimiento")

		if (player.global_position.x - global_position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity = Vector2.ZERO 
		$AnimatedSprite2D.play ("idle")

	move_and_slide()  

func _on_area_2d_body_entered(body):
		player = body
		player_chase = true
		
func _on_area_2d_body_exited(body):
		player = null
		player_chase = false

func _on_hitbox_sombra_body_entered(body: Node2D):
	if body.has_method("arma"):
		arma_en_enemigo = true

func get_damaged():
	if arma_en_enemigo == true and cooldown_enemigo == true:
		health = health - GlobalScript.attack_damage
		print("Vida sombra ", health)
		cooldown_enemigo = false
		$cooldown.start()

#todo mal
#seguramente con un @export funcione
#bobo

func _on_hitbox_sombra_body_exited(body: Node2D):
	if body.has_method("arma"):
		arma_en_enemigo = false

func _on_cooldown_timeout():
	cooldown_enemigo = true
