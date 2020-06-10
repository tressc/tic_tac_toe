extends Node2D
const SpaceClass = preload("res://space.tscn")
onready var globals = get_node("/root/globals")
var rng = RandomNumberGenerator.new()
var boardState = {}
const spaces = []

func _ready():
	clearBoard()
	for i in range(9):
		var space = SpaceClass.instance()
		space.connect("mark_x", self, "updatePos", [i, 1])
		space.connect("mark_o", self, "updatePos", [i, 4])
		spaces.append(space)		
		$Control/GridContainer.add_child(space)
		
func checkFilledSpaces():
	for space in spaces:
		if (!space.isFilled):
			return false
	return true
	
func checkForWin():
	for line in boardState:
		if ([3, 12].has(boardState[line])):
			return true
	return false

func checkGameOver():
	if (checkFilledSpaces() or checkForWin()):
		globals.gameOver = true
		restart()
		
func clearBoard():
	boardState = {}
	for i in range(8):
		boardState[i] = 0
		
func updateGame():
	globals.humanTurn = !globals.humanTurn
	checkGameOver()
	if (!globals.humanTurn and !globals.gameOver):
		botMove()
		
func updatePos(pos, val):
	boardState[pos % 3] += val
	for i in range(3):
		if (pos < (i + 1) * 3):
			boardState[i + 4] += val
			break
	if ([2, 4, 6].has(pos)):
		boardState[3] += val
	if (pos % 4 == 0):
		boardState[7] += val
	updateGame()
		
func botMove():
	yield(get_tree().create_timer(0.5), "timeout")
	var idx = rng.randi_range(0, len(spaces) - 1)
	while (spaces[idx].isFilled):
		idx = rng.randi_range(0, len(spaces) - 1)
	spaces[idx].markSpace()
	
func restart():
	yield(get_tree().create_timer(1), "timeout")	
	globals.gameOver = false
	clearBoard()
	for space in spaces:
		space.reset()
	if (!globals.humanTurn):
		botMove()