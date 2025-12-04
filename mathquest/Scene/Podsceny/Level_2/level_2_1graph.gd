extends Panel

var a: float = 0
var b: float = 0
var x: float = 0
var f: Callable = Callable()

@export var scale_x: float = 40.0
@export var scale_y: float = 40.0

func _draw():
	if not f.is_valid():
		return

	var offset := size / 2


	draw_line(offset + Vector2(-size.x/2,0), offset + Vector2(size.x/2,0), Color.WHITE, 1)
	draw_line(offset + Vector2(0,-size.y/2), offset + Vector2(0,size.y/2), Color.WHITE,1)

	var prev_point = offset + Vector2(-size.x/2, -f.call(-size.x/(2*scale_x)) * scale_y)
	for i in range(-int(size.x/2), int(size.x/2)):
		var xx = i / scale_x
		var yy = -f.call(xx) * scale_y
		var point = offset + Vector2(i, yy)
		draw_line(prev_point, point, Color.YELLOW, 2)
		prev_point = point

	draw_circle(offset + Vector2(a*scale_x, -f.call(a)*scale_y), 5, Color.RED)
	draw_circle(offset + Vector2(b*scale_x, -f.call(b)*scale_y), 5, Color.BLUE)
	draw_circle(offset + Vector2(x*scale_x, -f.call(x)*scale_y), 5, Color.GREEN)
