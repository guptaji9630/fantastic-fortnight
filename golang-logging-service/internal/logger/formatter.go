package logger

import (
	"fmt"
	"log"
	"time"
)

type LogFormatter struct{}

func (f *LogFormatter) Format(level string, message string) string {
	currentTime := time.Now().Format("2006-01-02 15:04:05")
	return fmt.Sprintf("[%s] [%s] %s", currentTime, level, message)
}

func (f *LogFormatter) Info(message string) {
	log.Println(f.Format("INFO", message))
}

func (f *LogFormatter) Warn(message string) {
	log.Println(f.Format("WARN", message))
}

func (f *LogFormatter) Debug(message string) {
	log.Println(f.Format("DEBUG", message))
}

func (f *LogFormatter) Error(message string) {
	log.Println(f.Format("ERROR", message))
}