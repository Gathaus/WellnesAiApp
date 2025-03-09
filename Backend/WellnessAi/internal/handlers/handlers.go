package handlers

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"WellnessAi/internal/config"
	"WellnessAi/internal/database"
	"WellnessAi/internal/models"

	"github.com/gorilla/mux"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Handlers contains all the HTTP handlers and their dependencies
type Handlers struct {
	DB *database.Database
}

// NewHandlers creates a new Handlers instance with the given database
func NewHandlers(db *database.Database) *Handlers {
	return &Handlers{DB: db}
}

// CreateUser handles the creation of a new user
func (h *Handlers) CreateUser(w http.ResponseWriter, r *http.Request) {
	var user models.User
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	user.CreatedAt = time.Now()
	user.ID = primitive.NewObjectID()

	collection := h.DB.DB.Collection("users")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	result, err := collection.InsertOne(ctx, user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	user.ID = result.InsertedID.(primitive.ObjectID)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

// GetUser handles retrieving a user by ID
func (h *Handlers) GetUser(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	var user models.User
	collection := h.DB.DB.Collection("users")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	err = collection.FindOne(ctx, bson.M{"_id": id}).Decode(&user)
	if err != nil {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

// UpdateUser handles updating a user's information
func (h *Handlers) UpdateUser(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	var user models.User
	err = json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	collection := h.DB.DB.Collection("users")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	update := bson.M{
		"$set": bson.M{
			"name": user.Name,
		},
	}

	result := collection.FindOneAndUpdate(ctx, bson.M{"_id": id}, update, options.FindOneAndUpdate().SetReturnDocument(options.After))
	if result.Err() != nil {
		http.Error(w, result.Err().Error(), http.StatusInternalServerError)
		return
	}

	if err = result.Decode(&user); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

// LogMood handles logging a user's mood
func (h *Handlers) LogMood(w http.ResponseWriter, r *http.Request) {
	var moodEntry models.MoodHistoryEntry
	err := json.NewDecoder(r.Body).Decode(&moodEntry)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	moodEntry.ID = primitive.NewObjectID()
	if moodEntry.Date.IsZero() {
		moodEntry.Date = time.Now()
	}

	collection := h.DB.DB.Collection("moodHistory")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	// Check if entry for this date already exists
	filter := bson.M{
		"userId": moodEntry.UserID,
		"date": bson.M{
			"$gte": database.TruncateToDay(moodEntry.Date),
			"$lt":  database.TruncateToDay(moodEntry.Date).Add(24 * time.Hour),
		},
	}

	var existingEntry models.MoodHistoryEntry
	err = collection.FindOne(ctx, filter).Decode(&existingEntry)
	if err == nil {
		// Entry exists, update it
		update := bson.M{
			"$set": bson.M{
				"mood": moodEntry.Mood,
				"date": moodEntry.Date,
			},
		}
		result, err := collection.UpdateOne(ctx, bson.M{"_id": existingEntry.ID}, update)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		if result.ModifiedCount == 0 {
			http.Error(w, "Failed to update mood entry", http.StatusInternalServerError)
			return
		}

		moodEntry.ID = existingEntry.ID
	} else {
		// Insert new entry
		result, err := collection.InsertOne(ctx, moodEntry)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		moodEntry.ID = result.InsertedID.(primitive.ObjectID)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(moodEntry)
}

// GetUserMoodHistory handles retrieving a user's mood history
func (h *Handlers) GetUserMoodHistory(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	userID, err := primitive.ObjectIDFromHex(params["userId"])
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	collection := h.DB.DB.Collection("moodHistory")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	// Get entries for the last 7 days
	filter := bson.M{
		"userId": userID,
		"date": bson.M{
			"$gte": time.Now().AddDate(0, 0, -7),
		},
	}

	cursor, err := collection.Find(ctx, filter, options.Find().SetSort(bson.M{"date": -1}))
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var moodHistory []models.MoodHistoryEntry
	if err = cursor.All(ctx, &moodHistory); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(moodHistory)
}

// Health handles the API health check endpoint
func (h *Handlers) Health(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]bool{"ok": true})
}