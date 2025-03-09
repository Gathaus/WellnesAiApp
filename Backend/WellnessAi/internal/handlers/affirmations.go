package handlers

import (
	"context"
	"encoding/json"
	"math/rand"
	"net/http"
	"time"

	"WellnessAi/internal/config"
	"WellnessAi/internal/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// GetAllAffirmations handles retrieving all affirmations
func (h *Handlers) GetAllAffirmations(w http.ResponseWriter, r *http.Request) {
	collection := h.DB.DB.Collection("affirmations")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var affirmations []models.Affirmation
	if err = cursor.All(ctx, &affirmations); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(affirmations)
}

// GetRandomAffirmation handles retrieving a random affirmation
func (h *Handlers) GetRandomAffirmation(w http.ResponseWriter, r *http.Request) {
	collection := h.DB.DB.Collection("affirmations")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	// Get count of all affirmations
	count, err := collection.CountDocuments(ctx, bson.M{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if count == 0 {
		http.Error(w, "No affirmations found", http.StatusNotFound)
		return
	}

	// Get a random number between 0 and count-1
	skip := rand.Int63n(count)

	// Find one random affirmation
	opts := options.FindOne().SetSkip(skip)
	var affirmation models.Affirmation
	err = collection.FindOne(ctx, bson.M{}, opts).Decode(&affirmation)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(affirmation)
}