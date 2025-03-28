package logger

import (
	"fmt"
	"io"
	"os"
	"path/filepath"

	"github.com/sirupsen/logrus"
	"gopkg.in/natefinch/lumberjack.v2"
)

type Logger struct {
	*logrus.Logger
}

// NewLogger creates a new logger with the given level and output
func NewLogger(level string, outputPath string) (*Logger, error) {
	log := logrus.New()

	// Parse log level
	logLevel, err := logrus.ParseLevel(level)
	if err != nil {
		return nil, fmt.Errorf("invalid log level: %s", level)
	}
	log.SetLevel(logLevel)

	// Configure output
	if outputPath != "" {
		// Create directory if it doesn't exist
		dir := filepath.Dir(outputPath)
		if err := os.MkdirAll(dir, 0755); err != nil {
			return nil, fmt.Errorf("failed to create log directory: %v", err)
		}

		// Configure log rotation
		lumberjackLogger := &lumberjack.Logger{
			Filename:   outputPath,
			MaxSize:    10, // MB
			MaxBackups: 5,
			MaxAge:     30, // days
			Compress:   true,
		}

		// Use both file and stdout
		multiWriter := io.MultiWriter(os.Stdout, lumberjackLogger)
		log.SetOutput(multiWriter)
	}

	// Configure log format
	log.SetFormatter(&logrus.JSONFormatter{
		TimestampFormat: "2006-01-02T15:04:05.000Z07:00",
	})

	return &Logger{log}, nil
}

// Info logs an info message
func (l *Logger) Info(msg string) {
	l.Logger.Info(msg)
}

// Warn logs a warning message
func (l *Logger) Warn(msg string) {
	l.Logger.Warn(msg)
}

// Debug logs a debug message
func (l *Logger) Debug(msg string) {
	l.Logger.Debug(msg)
}

// Error logs an error message
func (l *Logger) Error(msg string) {
	l.Logger.Error(msg)
}

// Infof logs a formatted info message
func (l *Logger) Infof(format string, args ...interface{}) {
	l.Logger.Infof(format, args...)
}

// Warnf logs a formatted warning message
func (l *Logger) Warnf(format string, args ...interface{}) {
	l.Logger.Warnf(format, args...)
}

// Debugf logs a formatted debug message
func (l *Logger) Debugf(format string, args ...interface{}) {
	l.Logger.Debugf(format, args...)
}

// Errorf logs a formatted error message
func (l *Logger) Errorf(format string, args ...interface{}) {
	l.Logger.Errorf(format, args...)
}

// Fatalf logs a formatted fatal message and exits
func (l *Logger) Fatalf(format string, args ...interface{}) {
	l.Logger.Fatalf(format, args...)
}