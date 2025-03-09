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

// GetAllWellnessTips handles retrieving all wellness tips
func (h *Handlers) GetAllWellnessTips(w http.ResponseWriter, r *http.Request) {
	collection := h.DB.DB.Collection("wellnessTips")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var tips []models.WellnessTip
	if err = cursor.All(ctx, &tips); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tips)
}

// GetWellnessTipsByCategory handles retrieving wellness tips by category
func (h *Handlers) GetWellnessTipsByCategory(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	category := params["category"]

	collection := h.DB.DB.Collection("wellnessTips")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	filter := bson.M{"category": category}
	cursor, err := collection.Find(ctx, filter)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var tips []models.WellnessTip
	if err = cursor.All(ctx, &tips); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tips)
}