package routes

import (
	"github.com/gorilla/mux"
	"WellnessAi/internal/handlers"
)

// SetupRoutes configures all the routes for the application
func SetupRoutes(h *handlers.Handlers) *mux.Router {
	router := mux.NewRouter()

	// User routes
	router.HandleFunc("/api/users", h.CreateUser).Methods("POST")
	router.HandleFunc("/api/users/{id}", h.GetUser).Methods("GET")
	router.HandleFunc("/api/users/{id}", h.UpdateUser).Methods("PUT")

	// Mood history routes
	router.HandleFunc("/api/mood", h.LogMood).Methods("POST")
	router.HandleFunc("/api/mood/user/{userId}", h.GetUserMoodHistory).Methods("GET")

	// Goals routes
	router.HandleFunc("/api/goals", h.CreateGoal).Methods("POST")
	router.HandleFunc("/api/goals/user/{userId}", h.GetUserGoals).Methods("GET")
	router.HandleFunc("/api/goals/{id}", h.UpdateGoal).Methods("PUT")
	router.HandleFunc("/api/goals/{id}", h.DeleteGoal).Methods("DELETE")

	// Messages routes
	router.HandleFunc("/api/messages", h.SaveMessages).Methods("POST")
	router.HandleFunc("/api/messages/user/{userId}", h.GetUserMessages).Methods("GET")

	// User settings routes
	router.HandleFunc("/api/settings", h.SaveUserSettings).Methods("POST")
	router.HandleFunc("/api/settings/user/{userId}", h.GetUserSettings).Methods("GET")

	// Meditation routes
	router.HandleFunc("/api/meditations", h.GetAllMeditations).Methods("GET")
	router.HandleFunc("/api/meditations/type/{type}", h.GetMeditationsByType).Methods("GET")

	// Wellness tips routes
	router.HandleFunc("/api/tips", h.GetAllWellnessTips).Methods("GET")
	router.HandleFunc("/api/tips/category/{category}", h.GetWellnessTipsByCategory).Methods("GET")

	// Affirmations routes
	router.HandleFunc("/api/affirmations", h.GetAllAffirmations).Methods("GET")
	router.HandleFunc("/api/affirmations/random", h.GetRandomAffirmation).Methods("GET")

	// Health check route
	router.HandleFunc("/api/health", h.Health).Methods("GET")

	return router
}