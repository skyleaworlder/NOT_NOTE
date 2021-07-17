package main

import (
	"context"
	"fmt"
	"time"
)

func main() {

	buf := make(chan int, 2)

	bkctx := context.Background()
	ctx, cancel := context.WithCancel(bkctx)

	// consumer
	go func(ctx context.Context) {
		for {
			time.Sleep(time.Second)
			select {
			case <-ctx.Done():
				fmt.Println("oh no!")
			case <-buf:
				fmt.Println("lalala")
			default:
				fmt.Println("default")
			}
		}
	}(ctx)

	// producer
	for i := 0; i < 3; i++ {
		buf <- i
	}
	time.Sleep(4 * time.Second)
	cancel()
	time.Sleep(2 * time.Second)
	fmt.Println("main process exit!")
}
