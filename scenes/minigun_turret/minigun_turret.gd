extends BaseTurret
class_name MinigunTurret

var barrel_length = 100 # 炮管长度，炮弹在炮口生成
@onready var cannon_shell_t = preload("res://scenes/projectiles/cannon/cannon.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
