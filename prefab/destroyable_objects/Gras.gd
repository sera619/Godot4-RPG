extends Node

@export var effect_scene: PackedScene
@export var max_health: int = 1
@export var respawn: bool
@export var respawn_time: int

@onready var hitbox: Area2D = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D
@onready var shadow: Sprite2D = $Sprite2D2
@onready var respawn_timer: Timer = $Timer
@onready var collider_shape: = $Hitbox/CollisionShape2D 
@onready var health: int = 0

func _ready():
	self.health = max_health
	hitbox.connect("area_entered", on_area_entered)
	if respawn == true:
		respawn_timer.connect("timeout", respawn_object)

func respawn_object():
	collider_shape.call_deferred("set_disabled", false)
	sprite.visible = true
	shadow.visible = true
	self.health = max_health

func on_area_entered(area):
	if not area.is_in_group("playerSword"):
		return
	if health >= 0:
		self.health -= area.damage
		if health < 0:
			var effect = effect_scene.instantiate()
			get_tree().current_scene.add_child(effect)
			effect.global_position = sprite.global_position
			sprite.visible = false
			shadow.visible = false
			collider_shape.call_deferred("set_disabled", true)
			if respawn == true:
				respawn_timer.wait_time = respawn_time
				respawn_timer.start()
				print("[!] GrasObject: Respawntime %s started!" % respawn_time)
