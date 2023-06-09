extends Area2D
class_name BaseTurret

var angularspeed:float = 0.5 # 炮塔旋转角速度 rad/s

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func process_angle(angle: float)->float:
	var beishu :int = abs(angle)/(2*PI)
	#print("beishu", beishu)
	if beishu > 0:
		if angle >0:
			angle -= beishu*2*PI
			
		else:
			angle += beishu*2*PI
	#print(angle)	
	if angle > PI:
		angle -=2*PI			
	if angle < -PI:	
		angle += 2*PI
	
	return angle
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var deltapos:Vector2 = self.get_global_mouse_position() - self.global_position
	var should_rotate:float = deltapos.angle() - self.global_rotation  # 因该旋转的弧度
	should_rotate = self.process_angle(should_rotate)
	#print("应该旋转", should_rotate)
	if abs(should_rotate) < 0.001:
		return
	if should_rotate >0:
		self.global_rotation += angularspeed * delta
	else:
		self.global_rotation -= angularspeed * delta
	#self.global_rotation
	# self.look_at(pos)