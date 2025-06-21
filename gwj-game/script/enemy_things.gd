extends CharacterBody2D


var speed = 100

var health = 100

var dead = false
var player_in_area = false
var player

func _ready() -> void:
	dead = false
	
func _physics_process(delta: float) -> void:
	if !dead:
		$PlayerDetectionArea/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed
			$AnimatedSprite.play("Move")
			
		else:
			$AnimatedSprite.play("Idle")

		if dead:
			$PlayerDetectionArea/CollisionShape2D.disabled = true


func _on_player_detection_area_body_entered(body: Node2D) -> void:
		if body.has_method("player"):
			player_in_area = true
			player = body


func _on_player_detection_area_body_exited(body: Node2D) -> void:
		if body.has_method("player"):
			player_in_area = false


func _on_hitbox_area_entered(area: Area2D) -> void:
	var damage
	print("something entered ",area.name)
	print("Enemy health :", health)
	if area.has_method("bullet"):
		damage = 50
		take_damage(damage)
	if area.name == "DamgeTestBox":
		damage = 50
		take_damage(damage)

func take_damage(damage):
	health = health - damage
	if health <=0 and !dead:
		death()
		
func death():
	dead = true
	$AnimatedSprite.play("Death")
	await get_tree().create_timer(1).timeout
	queue_free()
