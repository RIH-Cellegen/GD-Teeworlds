extends KinematicBody2D
var vel = Vector2() # Coordinated velocity.
var max_vel = 16 # 16 blocks / second is Teeworlds' movement.
var pixel_rate = 32 # Referenced as a block transmiter.
var jumps = 2 # Total amount of jumps
var current_jumps = 0 # Calculation for jump_change.
var jump_change = 0 # This value will be the current value of jumps.
func _physics_process(delta) -> void:
	vel.y += 0.5 * 32 # Gravity
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") # Inputs here are references as | 1 for Right | 0 for idle | -1 for left |.
	if input_x != 0: # If we move:
		walk()
		if is_on_floor(): # And it's on ground:
			max_vel = 16 # Maximum velocity should be 16.
		else: # And it's on air:
			if vel.x > -256 and vel.x < 256: # If we hit a lesser limit with vel.x:
				max_vel = 8 # Then the limit should be this number, when changing directions.
	if input_x == 0: # If we don't move:
		if is_on_floor(): # And it's on ground:
			stop_ground()
		else: # And it's on air:
			stop_air()
	if is_on_floor(): # If it's on ground:
		jump_change = 0 # It'll reset the jump counter, so it won't stack.
		if Input.is_action_just_pressed("ui_up"): # When UP is pressed:
			if jump_change == 0: # It's needed to separate jumping() from air_jumping().
				jumping() # 
	else: # If it's on air:
		if jump_change == 0: # If you fell off an edge without pressing up:
			jump_change = 1  # It'll add one counter as used, so you can air jump correctly.
		if Input.is_action_just_pressed("ui_up"): # When UP is pressed:
			if jump_change <= jumps - 1: # It'll only call, if the jump counter is not equal or bigger, than our jumps value. (maximum jump available) Limits the number of airjumps perfectly.
				air_jumping()
	vel = move_and_slide(vel, Vector2.UP) # Nessesary for movement. (Keep it on last codeline for best efficiency.)
func walk() -> void: # from 0 to max_vel, every frame vel_change adds 3 to vel_speed.
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") # Inputs here are references as | 1 for Right | 0 for idle | -1 for left |.
	vel.x += lerp(0, max_vel * pixel_rate * input_x, 0.1875) # 0.1875 is the nessesary value to increase it by 3, every frame to max_vel.
	vel.x = clamp(vel.x, -max_vel * pixel_rate, max_vel * pixel_rate) # Limitation for vel.x, so it won't overincrease max_vel.
func stop_ground() -> void: # vel divides itself by half every frame, until reached 0.
	vel.x = vel.x * 0.5
func stop_air() -> void: # vel divides itself by a small amount every frame, until reached 0.
	vel.x = vel.x * 0.95
func jumping() -> void: # vel.y will increase upwards by 528 pixels (6 and half blocks), also adds a jump counter once, when called.
	vel.y = -528
	jump_change += 1
func air_jumping() -> void: # current jump will have a limitation rule connected with jumps, and vel.y will increase upwards by 478 (around 4 blocks) + adding a jump counter, when called.
	current_jumps = clamp(jump_change, 0, jumps)
	vel.y = -478
	jump_change += 1
