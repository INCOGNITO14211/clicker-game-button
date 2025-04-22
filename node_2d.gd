extends Node2D
#Make the animations play when you "beat" the game
# Prestige and scoring variables
var prestige_points = 0
var prestige_multiplier = 1
var prestige_threshold = 10000
var score = 0

# Click power and auto-click rate variables
var click_power = 1
var auto_click_rate = 0
var scaling_factor = 1.5

# Base costs for upgrades
var base_cost = 10
var base_cost2 = 50

# Upgrade cost variables (calculated using your scaling factor)
var click_power_cost = base_cost * (scaling_factor ** click_power)
var auto_clicker_cost = base_cost2 * (scaling_factor ** auto_click_rate)

# NEW: Variables to control auto‑click frequency upgrade.
# auto_click_interval represents the Timer's wait time (in seconds).
var auto_click_interval = 1.0   # Starting at 1 second per tick.
var auto_click_frequency_cost = 50  # Cost to reduce the wait time (i.e. increase frequency).
var frequency_scaling_factor = 1.3  # Multiply cost by this factor for each upgrade.

# Variables for tracking clicks per second
var click_count: int = 0  # Number of clicks within the current second
var cps: int = 0          # Clicks per second (updated every second)

# Array of achievement dictionaries.
var achievements = [
	{"name": "Finally you actually clicked", "description": "Click for the first time", "unlocked": false},
	{"name": "Ok now we're getting somewhere", "description": "Get an uninterrupted streak of 10 clicks", "unlocked": false},
	{"name": "Prestiged", "description": "Perform your first prestige", "unlocked": false},
	{"name": "Powerful clicker", "description": "Buy 50 Click Power upgrades", "unlocked": false},
	{"name": "afk", "description": "Buy 20 click rate upgrades", "unlocked": false},
	{"name": "Good job you 100% my game", "description": "have all other achievments", "unlocked": false},
]

#auto click timer
func _ready() -> void:
	# Assuming you have a Timer node named "Timer" as a child of this Node2D.
	$Timer.wait_time = auto_click_interval
#main clicking button
func _on_button_pressed() -> void:
	score += click_power * prestige_multiplier
	$ScoreLabel.text = str(int(score))
	click_count += 1
	update_ui()
#click power upgrades
func _on_increase_click_powe_upgrade_pressed() -> void:
	if score >= click_power_cost:
		score -= click_power_cost
		click_power += 1
		click_power_cost *= 1.125  # Increase cost for the next upgrade
		update_ui()
#autoclicker power upgrade
func _on_auto_clicker_button_pressed() -> void:
	if score >= auto_clicker_cost:
		score -= auto_clicker_cost
		auto_click_rate += 5
		auto_clicker_cost *= 1.3
		update_ui()
#power of autoclicker timer
func _on_timer_timeout() -> void:
	score += auto_click_rate
	update_ui()
#prestiges
func _on_prestige_button_pressed() -> void:
	if score >= prestige_threshold:
		prestige_points += 1 
		prestige_multiplier += 7 * prestige_points
		score = 0
		# Optionally reset upgrades (if desired)
		click_power = 1
		auto_click_rate = 0
		click_power_cost = base_cost * (scaling_factor ** click_power)
		auto_clicker_cost = base_cost2 * (scaling_factor ** auto_click_rate)
		prestige_threshold *= 10
		update_ui()
#all the label and button text
func update_ui() -> void:
	$ScoreLabel.text = str(int(score))
	$ClickPowerButton.text = "Click Power: $" + str(int(click_power_cost))
	$AutoClickerButton.text = "Auto-Clicker: $" + str(int(auto_clicker_cost))
	# Make sure you have a button for this upgrade named "AutoClickFrequencyButton" in your scene.
	$AutoClickFrequencyButton.text = "Auto Frequency:$" + str(int(auto_click_frequency_cost)) + ("(does not reset on prestige)")
	$PrestigeButton.text = "prestige:$" +str(prestige_threshold)
	update_achievements_display()
	check_for_achievements()
#time it takes to autoclick
func _on_auto_click_frequency_button_pressed() -> void:
	if score >= auto_click_frequency_cost:
		score -= auto_click_frequency_cost
		# Decrease the interval by 10% to increase auto-click frequency.
		auto_click_interval *= 0.9
		$Timer.wait_time = auto_click_interval
		auto_click_frequency_cost *= frequency_scaling_factor
		update_ui()
#clicks per second timer
func _on_cps_timer_timeout() -> void:
 # The number of clicks measured in the last second is the CPS.
	cps = click_count

	# Update the CPS label
	$CpsLabel.text = "Clicks per second: " + str(cps)
	
	# Reset the click count for the next interval
	click_count = 0
#achievement checker
func check_for_achievements() -> void:
	# Example: Unlock "First Click" when score is at least 1.
	if score >= 1 and not achievements[0]["unlocked"]:
		achievements[0]["unlocked"] = true

	# Example: Unlock "Click Streak" for 10 clicks.
		achievements[1]["unlocked"] = true

	# Example: Unlock "Prestige Unlocked" when a prestige occurs.
	# (Assuming you handle this in your prestige function.)
	# if /* your condition for prestige */ and not achievements[2]["unlocked"]:
	#     achievements[2]["unlocked"] = true

	# Unlock the "Power Up Pro" achievement once 100 click power upgrades have been purchased.
	# Since click_power starts at 1, upgrading 100 times makes it 101.
	if click_power >= 51 and not achievements[3]["unlocked"]:
		achievements[3]["unlocked"] = true
	if auto_click_rate >= 100 or auto_click_interval <= 0.6 and not achievements[4]["unlocked"]:
		achievements[4]["unlocked"] = true
	if prestige_multiplier >1 and not achievements[5]["unlocked"]:
		achievements[5]["unlocked"] = true
	# Achievement 6: "Good job you 100% my game" — unlocked when achievements 0–4 are all unlocked.
	var all_other_unlocked = true
	for i in range(0, 5):
		if not achievements[i]["unlocked"]:
			all_other_unlocked = false
			break
	if all_other_unlocked and not achievements[5]["unlocked"]:
		achievements[5]["unlocked"] = true
	update_achievements_display()
#achievement displayer
func update_achievements_display() -> void:
	var achievement_display = "Achievements:\n\n"
	for achievement in achievements:
		if achievement["unlocked"]:
			achievement_display += achievement["name"] + " - Unlocked!\n"
		else:
			achievement_display += achievement["name"] + " - Locked\n"
	$AchievementsLabel.text = achievement_display
