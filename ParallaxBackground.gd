extends ParallaxBackground

func _process(delta):
    scroll_offset.x -= 50 * delta
    scroll_offset.y += 50 * delta
