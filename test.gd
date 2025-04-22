extends Node2D

# --- Base Game Variables ---
var score: float = 0
var click_power: float = 1

# --- Prestige Variables ---
var prestige_points: int = 0
var prestige_multiplier: float = 1.0
var prestige_threshold: float = 100000  # Score required to upgrade via prestige

# --- Auto-Clicker Upgrade Variables ---
var auto_click_rate: int = 0            # How many clicks per interval (for auto clicker)
var auto_clicker_base_cost: float = 50  # Base cost for auto-clicker upgrade
var auto_clicker_cost: float = auto_clicker_base_cost
var auto_clicker_level: int = 0         # Number of auto-clicker upgrades purchased

func _ready():
	update_ui()

# --- Click Button Function ---
func _on_ClickButton_pressed():
	# Increase score with the click power multiplied by the prestige bonus.
	score += click_power * prestige_multiplier
	update_ui()

# --- Auto-Clicker Upgrade Button Function ---
func _on_AutoClickerButton_pressed():
	buy_auto_clicker()

func buy_auto_clicker():
	if score >= auto_clicker_cost:
		score -= auto_clicker_cost
		auto_click_rate += 1
		auto_clicker_level += 1
		# Increase the cost. You can adjust the multiplier to balance the scaling.
		auto_clicker_cost *= 2  
		update_ui()
	else:
		print("Not enough score to buy auto-clicker upgrade!")

# --- Prestige Button Function ---
func _on_PrestigeButton_pressed():
	prestige()

func prestige():
	if score >= prestige_threshold:
		# Reward prestige: add one prestige point then boost multiplier
		prestige_points += 1
		prestige_multiplier += 0.1 * prestige_points
		
		# Reset the base game values
		score = 0
		click_power = 1
		
		# Reset auto-clicker upgrade values
		auto_click_rate = 0
		auto_clicker_cost = auto_clicker_base_cost
		auto_clicker_level = 0
		
		update_ui()
	else:
		print("Score not reached for prestige!")

# --- Updates the UI Labels ---
func update_ui():
	$ScoreLabel.text = "Score: " + str(score)
	$PrestigeLabel.text = "Prestige Points: " + str(prestige_points)
	$ClickButton.text = "Click! (x" + str(click_power) + ")"
	$AutoClickerButton.text = "Auto-Clicker Upgrade Cost: $" + str(auto_clicker_cost)
