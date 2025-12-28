extends Node2D
enum GameMode { CONWAY, SEEDS, BRIANS_BRAIN, DAY_NIGHT, RULE90, RULE184 }
var game_mode = GameMode.CONWAY
@onready var mode_menu =  $"../CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer3/GameMode"
@onready var scale_slider =  $"../CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer3/ScaleSlider"
@onready var gen_counter = $"../CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer3/GenCounter"

var grid_width = 160
var grid_height = 90
var cell_size = 7.2

var current_grid = []
var next_grid = []

var is_running = false
var update_speed = 0.1  # seconds between updates
var time_elapsed = 0.0
var generation = 0

var random_filter = 0.5

func _ready():
	initialize_grids()
	var popup = mode_menu.get_popup()
	popup.add_item("Conway's Game of Life", GameMode.CONWAY)
	popup.add_item("Seeds", GameMode.SEEDS)
	popup.add_item("Brian's Brain", GameMode.BRIANS_BRAIN)
	popup.add_item("Day and Night", GameMode.DAY_NIGHT)
	popup.add_item("Rule 90", GameMode.RULE90)
	popup.add_item("Rule 184", GameMode.RULE184)
	popup.index_pressed.connect(_on_mode_selected)

func _on_mode_selected(index):
	game_mode = index
	match game_mode: 
		GameMode.CONWAY: 
			mode_menu.text = "Conway's Life"
		GameMode.BRIANS_BRAIN:
			mode_menu.text = "Brian's Brain"
		GameMode.SEEDS:
			mode_menu.text = "Seeds"
		GameMode.RULE90:
			mode_menu.text = "Rule 90"
		GameMode.RULE184:
			mode_menu.text = "Rule 184"
		GameMode.DAY_NIGHT:
			mode_menu.text = "Day and Night"
	
func initialize_grids():
	current_grid = []
	next_grid = []
	for x in range(grid_width):
		current_grid.append([])
		next_grid.append([])
		for y in range(grid_height):
			current_grid[x].append(0)
			next_grid[x].append(0)

func randomize_grid():
	for x in range(grid_width):
		for y in range(grid_height):
			if (randf() < random_filter):
				current_grid[x][y] = 2
			else:
				current_grid[x][y] = 0
	queue_redraw()

func _process(delta):
	if is_running:
		time_elapsed += delta
		if time_elapsed >= update_speed: 
			time_elapsed = 0.0
			generation += 1
			match game_mode:
				GameMode.CONWAY:
					update_simulation_conway()
				GameMode.BRIANS_BRAIN: 
					update_simulation_brian()
				GameMode.SEEDS: 
					update_simulation_seeds()
				GameMode.RULE90: 
					update_simulation_rule90()
				GameMode.RULE184: 
					update_simulation_rule184()
				GameMode.DAY_NIGHT: 
					update_simulation_day_night()
			queue_redraw()

func update_simulation_conway():
	for x in range(grid_width):
		for y in range(grid_height):
			var neighbors = count_neighbors(x, y)
			var is_alive = current_grid[x][y] == 2
			
			if is_alive:
				if (neighbors == 2 or neighbors == 3):
					next_grid[x][y] = 2
				else:
					next_grid[x][y] = 0
			else:
				if (neighbors == 3):
					next_grid[x][y] = 2
				else:
					next_grid[x][y] = 0
	
	var temp = current_grid
	current_grid = next_grid
	next_grid = temp

func update_simulation_brian():
	for x in range(grid_width):
		for y in range(grid_height):
			var is_alive = current_grid[x][y] == 2
			var is_dying = current_grid[x][y] == 1
			
			if is_alive:
				next_grid[x][y] = 1
			elif is_dying:
				next_grid[x][y] = 0
			else:
				var neighbors = count_neighbors(x, y)
				if(neighbors == 2):
					next_grid[x][y] = 2
				else:
					next_grid[x][y] = 0
	
	var temp = current_grid
	current_grid = next_grid
	next_grid = temp

func update_simulation_seeds():
	for x in range(grid_width):
		for y in range(grid_height):
			var neighbors = count_neighbors(x, y)
			var is_alive = current_grid[x][y] == 2
			
			if is_alive:
				next_grid[x][y] = 0
			else:
				if (neighbors == 2):
					next_grid[x][y] = 2
				else:
					next_grid[x][y] = 0
	
	var temp = current_grid
	current_grid = next_grid
	next_grid = temp

func update_simulation_day_night():
	for x in range(grid_width):
		for y in range(grid_height):
			var neighbors = count_neighbors(x, y)
			var is_alive = current_grid[x][y] == 2
			
			if is_alive:
				if (neighbors == 3 or neighbors == 4 or neighbors == 6 or neighbors == 7 or neighbors == 8):
					next_grid[x][y] = 2
				else:
					next_grid[x][y] = 0
			else:
				if (neighbors == 3 or neighbors == 6 or neighbors == 7 or neighbors == 8):
					next_grid[x][y] = 2
				else:
					next_grid[x][y] = 0
	
	var temp = current_grid
	current_grid = next_grid
	next_grid = temp

func update_simulation_rule90():
	var y = generation % grid_height
	for x in range(grid_width-1):
		var left_neighbor = current_grid[x-1][y-1] == 2
		var right_neighbor = current_grid[x+1][y-1] == 2
		
		if(left_neighbor != right_neighbor):
			current_grid[x][y] = 2
		else:
			current_grid[x][y] = 0

func update_simulation_rule184():
	var y = generation % grid_height
	for x in range(grid_width-1):
		var left_neighbor = current_grid[x-1][y-1] == 2
		var cell = current_grid[x][y-1] == 2
		var right_neighbor = current_grid[x+1][y-1] == 2
		
		if(left_neighbor and !cell):
			current_grid[x][y] = 2
		if(cell and !right_neighbor):
			current_grid[x][y] = 0

func count_neighbors(x, y):
	var count = 0
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			
			var nx = (x + dx + grid_width) % grid_width
			var ny = (y + dy + grid_height) % grid_height
			
			if current_grid[nx][ny] == 2: 
				count += 1
	return count

func _draw():
	gen_counter.text = "%d generation" % generation
	# drawing each cell caused a noticeable lag, this is a rudementary fix, to draw groups of cells together
	for y in range(grid_height):
		var y_px = y * cell_size
		var x := 0
		while x < grid_width:
			var state = current_grid[x][y]
			if state == 0:
				x += 1
				continue
			var color
			if(state == 1):
				color = Color.DIM_GRAY
			else:
				color = Color.WHITE

			var start_x := x
			x += 1
			while x < grid_width and current_grid[x][y] == state:
				x += 1

			var run_width_px = (x - start_x) * cell_size
			var rect := Rect2(start_x * cell_size, y_px, run_width_px, cell_size)
			draw_rect(rect, color, true)


func _input(event):
	# Toggle cells
	if Input.is_mouse_button_pressed(1):
		var x_pos = event.position.x
		var y_pos = event.position.y
		var top_ui_bound = 528;
		var right_ui_bound = 776;
		var left_ui_bound = 376;
		if(!(x_pos > left_ui_bound and x_pos < right_ui_bound and y_pos > top_ui_bound)):
			var x = int(x_pos / cell_size)
			var y = int(y_pos / cell_size)
			if x >= 0 and x < grid_width and y >= 0 and y < grid_height: 
				match game_mode:
					GameMode.CONWAY, GameMode.SEEDS, GameMode.RULE90, GameMode.RULE184, GameMode.DAY_NIGHT:
						current_grid[x][y] = 2 - current_grid[x][y]
					GameMode.BRIANS_BRAIN: 
						if(current_grid[x][y] == 2):
							current_grid[x][y] = 0
						else: 
							current_grid[x][y] = current_grid[x][y] + 1
				queue_redraw()
	
	# Keyboard controls
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_SPACE:
				is_running = !is_running  # Play/Pause
			KEY_R:
				randomize_grid()  # Random
			KEY_C:
				_on_clear_button_pressed()  # Clear

func clear_grid():
	for x in range(grid_width):
		for y in range(grid_height):
			current_grid[x][y] = 0



func _on_step_button_pressed() -> void:
	is_running = true
	_process(update_speed)
	is_running = false


func _on_clear_button_pressed() -> void:
	clear_grid()
	generation = 0
	queue_redraw()


func _on_random_button_pressed() -> void:
	randomize_grid()


func _on_play_button_toggled(toggled_on: bool) -> void:
	is_running = toggled_on


func _on_h_slider_value_changed(value: float) -> void:
	update_speed = 1 / value


func _on_random_amount_slider_value_changed(value: float) -> void:
	random_filter = value


func _on_scale_slider_value_changed(value: float) -> void:
	var new_width = int(scale_slider.value)
	var new_height = int(new_width * 9 / 16)
	var new_cell_size = 1152.0 / new_width
	
	var new_current_grid = []
	next_grid = []
	
	for x in range(new_width):
		new_current_grid.append([])
		next_grid.append([])
		for y in range(new_height):
			var left_border = new_width/2-grid_width/2
			var right_border = new_width/2+grid_width/2
			var top_border = new_height/2-grid_height/2
			var bottom_border = new_height/2+grid_height/2
			# Copy existing cell data to larger grid
			if x > left_border and x < right_border and y > top_border and y < bottom_border: 
				new_current_grid[x].append(current_grid[x-left_border][y-top_border])
				next_grid[x].append(0)
			else:
				new_current_grid[x].append(0)
				next_grid[x].append(0)
	
	grid_width = new_width
	grid_height = new_height
	cell_size = new_cell_size
	
	current_grid = new_current_grid
	
	queue_redraw()
