extends State
class_name CardInParty

var is_in_party: bool

func enter():
	is_in_party = true
	
func exit():
	is_in_party = false
