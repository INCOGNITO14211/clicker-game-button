extends Node2D
var prestige_points = 0
var prestige_multiplier = 1
var prestige_threshold = 10000
var score = 100000
var click_power = 1
var upgrade_level = click_power
var upgrade_level2 = auto_click_rate
var auto_click_rate = 0
var scaling_factor=1.5
var base_cost = 10
var base_cost2 = 50
var click_power_cost = base_cost * (scaling_factor ** click_power)
var auto_clicker_cost = base_cost2 * (scaling_factor ** auto_click_rate)

func _on_button_pressed() -> void:
	score += click_power * prestige_multiplier
	$ScoreLabel.text = str(int(score))
	update_ui()

func _on_increase_click_powe_upgrade_pressed() -> void:
	if score >= click_power_cost:
		score -= click_power_cost
		click_power += 1
		click_power_cost *= 1.125  # Increase cost for the next upgrade
		update_ui()

func update_ui():
	$ScoreLabel.text = str(int(score))
	$ClickPowerButton.text = "Click Power: $" + str(int(click_power_cost))
	$AutoClickerButton.text = "Auto-Clicker: $" + str(int(auto_clicker_cost))

func _on_auto_clicker_button_pressed() -> void:
	if score >= auto_clicker_cost:
		score -= auto_clicker_cost
		auto_click_rate += 5
		auto_clicker_cost *= 1.3
		update_ui()

func _on_timer_timeout() -> void:
	score+=auto_click_rate
	update_ui()


func _on_prestige_button_pressed() -> void:
	if score >= prestige_threshold:
		prestige_points += 1 
		prestige_multiplier += 7 * prestige_points
		score = 0
		auto_click_rate = 0
		click_power = 1
		scaling_factor = 1.2
		update_ui()
