package main

import (
    "fmt"
    "os"
    "os/signal"
    "syscall"
    
    "golang-logging-service/internal/app"
    "golang-logging-service/internal/config"
    "golang-logging-service/internal/logger"
    "golang-logging-service/pkg/utils"
)

func main() {
    // Initialize utilities
    utils.Init()
    
    // Load configuration
    configPath := "configs/app.yaml"
    if len(os.Args) > 1 {
        configPath = os.Args[1]
    }
    
    cfg, err := config.LoadConfig(configPath)
    if err != nil {
        fmt.Printf("Error loading config: %v\n", err)
        os.Exit(1)
    }
    
    // Initialize logger
    log, err := logger.NewLogger(cfg.Application.LogLevel, cfg.Application.LogFile)
    if err != nil {
        fmt.Printf("Error initializing logger: %v\n", err)
        os.Exit(1)
    }
    
    // Log startup information
    log.Infof("Starting Golang Logging Service version %s", cfg.Application.Version)
    log.Infof("Environment: %s", cfg.Application.Environment)
    
    // Initialize server
    srv := app.NewServer(cfg, log)
    
    // Handle graceful shutdown
    c := make(chan os.Signal, 1)
    signal.Notify(c, os.Interrupt, syscall.SIGTERM)
    
    go func() {
        <-c
        log.Info("Shutting down server...")
        os.Exit(0)
    }()
    
    // Start HTTP server
    serverAddr := fmt.Sprintf(":%s", cfg.Application.Server.Port)
    log.Infof("Server listening on %s", serverAddr)
    if err := srv.Start(serverAddr); err != nil {
        log.Fatalf("Error starting server: %v", err)
    }
}