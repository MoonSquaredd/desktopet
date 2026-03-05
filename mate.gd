class_name Mate extends RefCounted

var name
var move_speed
var sheet: Image
var frames = SpriteFrames.new()

var state = "idle"

func _init(defs_path: String):
	var f = FileAccess.open(defs_path,FileAccess.READ)
	var settings = JSON.parse_string(f.get_as_text())
	name = settings.name
	move_speed = settings.move_speed
	sheet = Image.load_from_file((defs_path.get_base_dir()) + "/" + settings.sheet)
	for animation in settings.frames:
		frames.add_animation(animation)
		frames.set_animation_speed(animation,settings.frames[animation].size())
		for i in range(settings.frames[animation].size()):
			var position = Vector2(settings.frames[animation][i].x, settings.frames[animation][i].y)
			var size = Vector2(settings.frames[animation][i].w, settings.frames[animation][i].h)
			var crop = Image.create_empty(size.x,size.y,false,Image.FORMAT_RGBA8)
			crop.blit_rect(sheet,Rect2i(position,size),Vector2.ZERO)
			frames.add_frame(animation,ImageTexture.create_from_image(crop))
