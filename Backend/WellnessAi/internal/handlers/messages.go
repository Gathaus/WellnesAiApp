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
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// SaveMessages handles saving chat messages
func (h *Handlers) SaveMessages(w http.ResponseWriter, r *http.Request) {
	var messages []models.Message
	err := json.NewDecoder(r.Body).Decode(&messages)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	if len(messages) == 0 {
		http.Error(w, "No messages provided", http.StatusBadRequest)
		return
	}

	collection := h.DB.DB.Collection("messages")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	// Convert []Message to []interface{} for bulk insert
	var documents []interface{}
	for i := range messages {
		if messages[i].ID.IsZero() {
			messages[i].ID = primitive.NewObjectID()
		}
		if messages[i].Timestamp.IsZero() {
			messages[i].Timestamp = time.Now()
		}
		documents = append(documents, messages[i])
	}

	result, err := collection.InsertMany(ctx, documents)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(bson.M{"insertedCount": len(result.InsertedIDs)})
}

// GetUserMessages handles retrieving a user's chat messages
func (h *Handlers) GetUserMessages(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	userID, err := primitive.ObjectIDFromHex(params["userId"])
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	collection := h.DB.DB.Collection("messages")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	filter := bson.M{"userId": userID}
	opts := options.Find().SetSort(bson.M{"timestamp": 1})
	cursor, err := collection.Find(ctx, filter, opts)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var messages []models.Message
	if err = cursor.All(ctx, &messages); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(messages)
}