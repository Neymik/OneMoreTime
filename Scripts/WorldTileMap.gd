extends TileMap

enum CELL_TYPES {EMPTY = -1, ACTOR, OBJECT}

var children
var stale_children = false

func _ready():
	process_actor_spawn_conditions()
	refresh_children()


# Make sure to call this when necessary
# We don't want to be getting children everytime an actor tries to move.
func refresh_children():
	children = get_children()


# Iterate through EVERY object in the overworld and find the right one
# Could probably be done better
# Vadim - VERY BAD OTVRATITELNO MNE STIDNO CHTO YA ETO SKOPIROVAL - REFACTOR
func get_world_object(coordinates):
	for node in children:
		# Protects against certain situations where an object is queued to be
		# freed
		if !is_instance_valid(node):
			stale_children = true
			continue
		else:
			if world_to_map(node.position) == coordinates:
				return(node)
	if stale_children:
		stale_children = false
		refresh_children()


func request_interaction(requesting_object, direction):
	var cell_start = world_to_map(requesting_object.position)
	var cell_target = world_to_map(requesting_object.position) + direction
	var cell_obj = get_world_object(cell_target)
	if !cell_obj:
		return
	if cell_obj.obj_type != CELL_TYPES.ACTOR:
		return
	cell_obj.interact()


func request_move(requesting_object, direction):
	var cell_start = world_to_map(requesting_object.position)
	var cell_target = world_to_map(requesting_object.position) + direction
	var cell_target_type = get_cellv(cell_target)

	var cell_obj = get_world_object(cell_target)

	if false: # Vadim TODO add condition here
		if cell_obj.obj_type == CELL_TYPES.OBJECT:
			cell_obj.do_what_this_object_does()
			return update_world_obj_position(requesting_object,
					cell_start, cell_target)
	
	return update_world_obj_position(requesting_object,
			cell_start, cell_target)
		

func update_world_obj_position(requesting_object, cell_start, cell_target):
	# The cell the moving object was in is now free
	# set_cellv(cell_start, CELL_TYPES.EMPTY)

	# Divide by 2 because location 0,0 starts from the top left of the cell
	# and we want the object to be "in the middle" of the grid cell
	# return map_to_world(cell_target) + cell_size / 2
	
	requesting_object.position.y = (cell_target.y * cell_size.y)
	requesting_object.position.x = (cell_target.x * cell_size.x)
	
	return


# removes an object from children array. The object should queue_free itself,
# but we want the overworld to immediately know this cell is no longer occupied
func remove_from_active(obj):
	children.erase(obj)


# By default design, all potential actors are on scene, and those that do not
# meet their conditions to be present are removed
func process_actor_spawn_conditions():
	for obj in get_children():
		if "spawn_condition" in obj and !obj.spawn_condition():
			obj.call_deferred("free")
