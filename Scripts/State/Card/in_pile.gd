extends State
class_name CardInPile

var is_in_pile: bool

func enter():
	is_in_pile = true
	
func exit():
	is_in_pile = false
