extends KinematicBody2D

export var dialogic_popup_scene = "res://Scenes/dialogicPopup.tscn"

var velocity: Vector2 = Vector2()
var direction: Vector2 = Vector2()

func read_input (): 
	velocity = Vector2()

	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction = Vector2(-1, 0)
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction = Vector2(1, 0)
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction = Vector2(0, 1)

	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * 200)
	
func _physics_process(_delta):
	
	# check collisions
	var slide_count = get_slide_count()
	
	if !slide_count:
		pass
	
	for i in slide_count:
		var collision = get_slide_collision(i)
		
		if collision.collider.name == "TileMap":
			var tileMap = collision.collider
			var pos = tileMap.world_to_map(collision.position)
			var id = tileMap.get_cellv(pos)
			
			var dialogic_popup = get_node("dialogic_popup")
			if dialogic_popup:
				remove_child(dialogic_popup)
			
			dialogic_popup = load(dialogic_popup_scene).instance()
			add_child(dialogic_popup)
			dialogic_popup.name = "dialogic_popup"
			dialogic_popup.popup_data = "TileMap " + str(pos) + " " + str(id)
			dialogic_popup.get_node("Button").text = "Button for " + str(pos)
			dialogic_popup.connect("popup_clicked", self, "_on_popup_clicked")
			
			print()
			# tileMap.get_cellv(tileMap.world_to_map(coll_pos))
	
	read_input()

func _on_popup_clicked(popup_self):
	var dialog = Dialogic.start("timeline-colly")
	Dialogic.set_variable("collision_definition", popup_self.popup_data)
	remove_child(popup_self)
	add_child(dialog)
