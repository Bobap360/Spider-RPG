@tool
extends EditorPlugin

# A class member to hold the dock during the plugin life cycle.
var dock

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("WebTools", "Button", preload("res://scripts/ui/skill_web_tools.gd"), preload("res://icon.svg"))
	
	# Initialization of the plugin goes here.
	# Load the dock scene and instantiate it.
	dock = preload("res://addons/my_custom_dock/custom_dock.tscn").instantiate()

	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock.

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("WebTools")
	
	# Remove the dock.
	remove_control_from_docks(dock)
	# Erase the control from the memory.
	dock.free()
