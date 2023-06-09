extends BaseTurret
class_name MinigunTurret

var barrel_length = 100 # 炮管长度，炮弹在炮口生成
@onready var cannon_shell_t = preload("res://scenes/projectiles/bullet/bullet.tscn")
@export var accuracy: float = 0.8



func fire():
	var shell: Bullet = self.cannon_shell_t.instantiate()
	var rorate_vector = Vector2.from_angle(self.global_rotation)
	shell.global_position = self.global_position + rorate_vector * self.barrel_length 
	shell.speed = 500 * Vector2.from_angle(self.global_rotation + (1 - self.accuracy) * PI / 4 * (randf() - 0.5))
	self.get_node("/root").add_child(shell)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
