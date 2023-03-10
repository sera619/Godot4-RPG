extends Node2D
class_name Teleporter

var player: Player = null
@export_enum("WorldBase", "SmallCave", "Wood", "SwordCave", "Grasland") var teleport_location: String
@export var animated: bool

@onready var teleArea = $TeleportArea
@onready var playerDetector = $PlayerDetector
@onready var animSprite = $AnimatedSprite2D


func _ready():
	teleArea.connect("body_entered", start_teleport)
	if animated:
		playerDetector.connect("body_entered", open_portal)
		playerDetector.connect("body_exited", close_portal)
		animSprite.connect("animation_finished", animSprite_finished)
	animSprite.visible = false

func open_portal(body):
	if body.name == "Player":
		player = body
		animSprite.visible = true
		animSprite.play("open")

func start_teleport(body):
	if not body.name == "Player":
		return
	player = body
	EventHandler.connect("transition_black", teleport_player)
	EventHandler.emit_signal("start_transition")
	

func close_portal(body):
	if body.name == "Player":
		player = null
		animSprite.play("close")

func animSprite_finished():
	if animSprite.animation == "open":
		animSprite.play("loop")
	elif animSprite.animation == "loop":
		animSprite.play("close")
	else:
		animSprite.visible = false
		animSprite.stop()

func teleport_player():
	if player != null:
		EventHandler.disconnect("transition_black", teleport_player)
		match teleport_location:
			"WorldBase":
				GameManager.game.switch_gamelevel(teleport_location)
			"SmallCave":
				GameManager.game.switch_gamelevel(teleport_location)
			"Wood":
				GameManager.game.switch_gamelevel(teleport_location)
			"SwordCave":
				GameManager.game.switch_gamelevel(teleport_location)
			"Grasland":
				GameManager.game.switch_gamelevel(teleport_location)
		print("[!] Teleporter: Player -> %s!" % teleport_location)
