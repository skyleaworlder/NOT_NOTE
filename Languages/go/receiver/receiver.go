package main

import (
	"fmt"
)

// I is an interface
type I interface {
	Print()
}

// Ta is a struct
type Ta struct {
	val int
}

// Print is to implement I interface
func (ta *Ta) Print() {
	fmt.Println("this is Ta.Print pointer")
}

// Tb is a struct
type Tb struct {
	val int
}

// Print is to implement I interface
func (tb Tb) Print() {
	fmt.Println("this is Tb.Print val")
}

func main() {
	var i I
	tap := &Ta{val: 1}
	tav := Ta{val: 1}
	tbp := &Tb{val: 2}
	tbv := Tb{val: 2}

	i = tap
	i.Print()

	tap.Print()
	tav.Print()

	i = tbp
	i.Print()

	tbp.Print()
	tbv.Print()
}
