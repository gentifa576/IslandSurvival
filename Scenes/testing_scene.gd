extends Node2D

@onready var tree = $Tree

func _ready():
	Global_Resources.connect("resource_UI_update", update_UI,0)

func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		tree.get_node("Interactable").interact(null)
		
	if Input.is_action_just_released("Interact"):
		tree.get_node("Interactable").stop_interaction(null)
	
	

func update_UI(value):
	$CanvasLayer/RichTextLabel.text = "Wood: " + str(value)
