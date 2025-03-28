package utils

import (
    "fmt"
    "math/rand"
    "time"
)

// Init initializes the random number generator
func Init() {
    rand.Seed(time.Now().UnixNano())
}

// RandomInt generates a random integer between min and max
func RandomInt(min, max int) int {
    return rand.Intn(max-min) + min
}

// GenerateID generates a unique identifier
func GenerateID() string {
    return fmt.Sprintf("%d", RandomInt(100000, 999999))
}