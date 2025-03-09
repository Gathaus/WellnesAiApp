package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"WellnessAi/internal/config"
	"WellnessAi/internal/database"
	"WellnessAi/internal/handlers"
	"WellnessAi/internal/routes"
)

func main() {
	// Initialize database connection
	db, err := database.Connect()
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	// Initialize handlers with database dependency
	h := handlers.NewHandlers(db)

	// Get port from environment or use default
	port := os.Getenv("PORT")
	if port == "" {
		port = config.DefaultPort
	}

	// Setup router with all routes
	router := routes.SetupRoutes(h)

	// Start server
	fmt.Printf("Server running on :%s\n", port)
	log.Fatal(http.ListenAndServe(":"+port, router))
}