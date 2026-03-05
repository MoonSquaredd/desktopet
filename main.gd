extends Control

var mateScene = preload("res://mate.tscn")
var mates = {}

func _ready() -> void:
	var folder
	if OS.has_feature("standalone"):
		folder = OS.get_executable_path().get_base_dir() + "/pets"
	var dir = DirAccess.get_directories_at(folder)
	for i in range(dir.size()):
		var pet_node = mateScene.instantiate()
		var mate = Mate.new(folder + "/" + dir[i] + "/settings.json")
		pet_node.name = mate.name
		pet_node.get_node("sprite").sprite_frames = mate.frames
		pet_node.get_node("sprite").animation = "idle"
		pet_node.get_node("sprite").play()
		add_child(pet_node)
		mates[mate.name] = mate
	DisplayServer.window_set_mouse_passthrough([Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO])

func to_idle(mate):
	mate.state = "idle"
	get_node(mate.name).get_node("sprite").animation = "idle"

func move(mate:Mate,where:Vector2):
	var node = get_node(mate.name)
	if node.position.x < where.x:
		node.get_node("sprite").flip_h = false
	else: node.get_node("sprite").flip_h = true
	var duration = (node.position.x - where.x)/mate.move_speed
	if duration < 0: duration *= -1
	var tween = get_tree().create_tween()
	tween.tween_property(node,"position",where,duration)
	tween.finished.connect(to_idle.bind(mate))
	tween.play()
	node.get_node("sprite").animation = "walk"

func _process(_delta: float) -> void:
	for mate in mates:
		mate = mates[mate]
		var rng = randi_range(1,1000)
		if rng == 1 && mate.state != "moving":
			mate.state = "moving"
			move(mate,Vector2(randi_range(0,1280),640))

func _on_rigid_body_2d_mouse_entered() -> void:
	print(randi())
