package app

import (
    "net/http"
    "time"
    
    "github.com/gorilla/mux"
    "golang-logging-service/internal/config"
    "golang-logging-service/internal/logger"
    "golang-logging-service/pkg/utils"
)

type Server struct {
    Router *mux.Router
    Logger *logger.Logger
    Config *config.Config
}

func NewServer(cfg *config.Config, log *logger.Logger) *Server {
    s := &Server{
        Router: mux.NewRouter(),
        Logger: log,
        Config: cfg,
    }
    s.routes()
    return s
}

func (s *Server) routes() {
    s.Router.HandleFunc("/", s.handleHome()).Methods("GET")
    s.Router.HandleFunc("/info", s.logInfoDemo()).Methods("GET")
    s.Router.HandleFunc("/warn", s.logWarnDemo()).Methods("GET")
    s.Router.HandleFunc("/debug", s.logDebugDemo()).Methods("GET")
    s.Router.HandleFunc("/error", s.logErrorDemo()).Methods("GET")
    s.Router.HandleFunc("/health", s.healthCheck()).Methods("GET")
}

func (s *Server) handleHome() http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        s.Logger.Info("Home endpoint hit")
        w.Write([]byte("Welcome to the Golang Logging Service!"))
    }
}

func (s *Server) logInfoDemo() http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        id := utils.GenerateID()
        s.Logger.Infof("Info log demo request received. Request ID: %s", id)
        w.Write([]byte("Info log generated. Check your logs!"))
    }
}

func (s *Server) logWarnDemo() http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        id := utils.GenerateID()
        s.Logger.Warnf("Warning log demo request received. Request ID: %s", id)
        w.Write([]byte("Warning log generated. Check your logs!"))
    }
}

func (s *Server) logDebugDemo() http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        id := utils.GenerateID()
        s.Logger.Debugf("Debug log demo request received. Request ID: %s", id)
        w.Write([]byte("Debug log generated. Check your logs!"))
    }
}

func (s *Server) logErrorDemo() http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        id := utils.GenerateID()
        s.Logger.Errorf("Error log demo request received. Request ID: %s", id)
        w.Write([]byte("Error log generated. Check your logs!"))
    }
}

func (s *Server) healthCheck() http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte("OK"))
    }
}

func (s *Server) Start(addr string) error {
    s.Logger.Infof("Starting server on %s", addr)
    
    srv := &http.Server{
        Handler:      s.Router,
        Addr:         addr,
        WriteTimeout: 15 * time.Second,
        ReadTimeout:  15 * time.Second,
    }
    
    return srv.ListenAndServe()
}