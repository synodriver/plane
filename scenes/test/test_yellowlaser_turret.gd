extends Node2D

func _ready():
	self.get_node("YellowLaserTurret").angularspeed = 2
	self.get_node("YellowLaserTurret").position = Vector2(150,150)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				self.get_node("YellowLaserTurret").fire()
				


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.get_node("YellowLaserTurret").set_target(self.get_global_mouse_position())

