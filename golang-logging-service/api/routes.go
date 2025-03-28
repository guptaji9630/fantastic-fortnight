package api

import (
    "net/http"
    "github.com/gorilla/mux"
    "golang-logging-service/internal/app"
)

// InitializeRoutes sets up the API routes and their handlers
func InitializeRoutes() *mux.Router {
    router := mux.NewRouter()

    // Define your routes here
    router.HandleFunc("/api/example", app.ExampleHandler).Methods(http.MethodGet)

    return router
}