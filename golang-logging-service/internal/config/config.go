package config

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v2"
)

type ServerConfig struct {
	Port         string `yaml:"port"`
	ReadTimeout  string `yaml:"read_timeout"`
	WriteTimeout string `yaml:"write_timeout"`
}

type LogRotationConfig struct {
	MaxSize    string `yaml:"max_size"`
	MaxBackups int    `yaml:"max_backups"`
	MaxAge     int    `yaml:"max_age"`
}

type ApplicationConfig struct {
	Name        string           `yaml:"name"`
	Version     string           `yaml:"version"`
	Environment string           `yaml:"environment"`
	LogLevel    string           `yaml:"log_level"`
	LogFile     string           `yaml:"log_file"`
	LogRotation LogRotationConfig `yaml:"log_rotation"`
	Server      ServerConfig     `yaml:"server"`
}

type Config struct {
	Application ApplicationConfig `yaml:"application"`
}

func LoadConfig(filePath string) (*Config, error) {
	data, err := os.ReadFile(filePath)
	if err != nil {
		return nil, fmt.Errorf("error reading config file: %v", err)
	}

	// Process environment variables in config
	for key, val := range os.Environ() {
		// You could implement environment variable substitution here
		_ = key
		_ = val
	}

	var config Config
	if err := yaml.Unmarshal(data, &config); err != nil {
		return nil, fmt.Errorf("error unmarshalling config: %v", err)
	}

	return &config, nil
}