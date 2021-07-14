package main

import (
	"errors"
	"fmt"
)

type lruqueue struct {
	elems   []interface{}
	maxSize int
}

func (q *lruqueue) Enqueue(elem interface{}) (err error) {
	// traverse elems, check whether element exists in queue.elems or not
	// even if q.elems' size equal maxSize
	for i, e := range q.elems {
		if e == elem {
			// find the elem in q.elems
			// delete and append it to the tail of q.elems
			q.elems = append(q.elems[:i], q.elems[i+1:]...)
			q.elems = append(q.elems, elem)
			return
		}
	}

	// check size of q.elems
	if len(q.elems) == q.maxSize {
		errmsg := "queue.Enqueue error: elems's size equal maxSize, dequeue then enqueue"
		err = errors.New(errmsg)

		// if dequeue error, return total error
		if _, derr := q.dequeue(); derr != nil {
			return errors.New(errmsg + derr.Error())
		}

		q.elems = append(q.elems, elem)
		return
	}

	// elem input not found in q.elems
	q.elems = append(q.elems, elem)
	return
}

func (q *lruqueue) dequeue() (elem interface{}, err error) {
	if len(q.elems) == 0 {
		errmsg := "queue.dequeue error: elems's size is 0"
		err = errors.New(errmsg)
		return
	}
	elem, q.elems = q.elems[0], q.elems[1:]
	return
}

func main() {
	testcase := []int{
		2, 4, 1, 0, 7, 4, 3, 5, 5, 2, 4,
	}

	q := lruqueue{
		elems:   make([]interface{}, 0),
		maxSize: 5,
	}

	for _, v := range testcase {
		q.Enqueue(v)
		fmt.Println(q)
	}
}
