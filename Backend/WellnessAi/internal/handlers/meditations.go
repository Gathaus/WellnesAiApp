package handlers

import (
	"context"
	"encoding/json"
	"net/http"
	"time"

	"WellnessAi/internal/config"
	"WellnessAi/internal/models"

	"github.com/gorilla/mux"
	"go.mongodb.org/mongo-driver/bson"
)

// GetAllMeditations handles retrieving all meditations
func (h *Handlers) GetAllMeditations(w http.ResponseWriter, r *http.Request) {
	collection := h.DB.DB.Collection("meditations")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var meditations []models.Meditation
	if err = cursor.All(ctx, &meditations); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(meditations)
}

// GetMeditationsByType handles retrieving meditations by type
func (h *Handlers) GetMeditationsByType(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	meditationType := params["type"]

	collection := h.DB.DB.Collection("meditations")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	filter := bson.M{"type": meditationType}
	cursor, err := collection.Find(ctx, filter)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var meditations []models.Meditation
	if err = cursor.All(ctx, &meditations); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(meditations)
}