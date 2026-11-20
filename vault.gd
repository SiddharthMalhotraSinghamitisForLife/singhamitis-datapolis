extends StaticBody3D

func _ready():
    add_to_group("vault")

func interact():
    print("VAULT OPENED!")