extends Node2D
var is_enemy = true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				self.get_node("HeavyCannonTurret").fire()

	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("HeavyCannonTurret").position = Vector2(150,150)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.get_node("HeavyCannonTurret").set_target(self.get_global_mouse_position())
