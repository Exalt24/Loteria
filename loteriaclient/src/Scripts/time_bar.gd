extends Line2D

# Store the initial x position of the line to prevent extending to the left
var start_x : float
var end_x : float

func _ready():
	# Set the starting and ending x positions of the line
	start_x = points[0].x
	end_x = points[1].x

	# Ensure the timer starts with the line in its full state
	points[1].x = end_x

func _decreased():
	# Decrease the x value of the second point, but make sure it doesn't go left of the starting point
	points[1].x = max(start_x, points[1].x - 10)  # Ensure points[1].x never goes below start_x

func _is_time_to_die():
	# Check if the second point has reached the start position
	return points[1].x == start_x

func _on_timer_timeout():
	_decreased()

	# When the line reaches the starting point, reset it and continue
	if _is_time_to_die():
		print("Timer: resetting")
		# Reset points[1] to the original end position and restart the timer
		points[1].x = end_x
		$Timer.start()  # Restart the timer if you want it to loop
