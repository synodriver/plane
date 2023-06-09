extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered", Callable(self,"on_area_entered"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_area_entered(area: Area2D): # 直接撞上，直接爆炸
	self.get_parent().destroy()
