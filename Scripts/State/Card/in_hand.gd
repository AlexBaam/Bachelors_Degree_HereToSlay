extends State
class_name CardInHand

var is_in_hand: bool

func enter():
	is_in_hand = true
	
func exit():
	is_in_hand = false
