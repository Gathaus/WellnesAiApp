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
)

// CreateGoal handles the creation of a new goal
func (h *Handlers) CreateGoal(w http.ResponseWriter, r *http.Request) {
	var goal models.Goal
	err := json.NewDecoder(r.Body).Decode(&goal)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	goal.ID = primitive.NewObjectID()
	goal.CreatedAt = time.Now()

	collection := h.DB.DB.Collection("goals")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	result, err := collection.InsertOne(ctx, goal)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	goal.ID = result.InsertedID.(primitive.ObjectID)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(goal)
}

// GetUserGoals handles retrieving a user's goals
func (h *Handlers) GetUserGoals(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	userID, err := primitive.ObjectIDFromHex(params["userId"])
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	collection := h.DB.DB.Collection("goals")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	filter := bson.M{"userId": userID}
	cursor, err := collection.Find(ctx, filter)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var goals []models.Goal
	if err = cursor.All(ctx, &goals); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(goals)
}

// UpdateGoal handles updating a goal's information
func (h *Handlers) UpdateGoal(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	var goal models.Goal
	err = json.NewDecoder(r.Body).Decode(&goal)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	collection := h.DB.DB.Collection("goals")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	update := bson.M{
		"$set": bson.M{
			"title":       goal.Title,
			"type":        goal.Type,
			"targetDate":  goal.TargetDate,
			"isCompleted": goal.IsCompleted,
		},
	}

	result, err := collection.UpdateOne(ctx, bson.M{"_id": id}, update)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if result.ModifiedCount == 0 {
		http.Error(w, "Goal not found or not modified", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(bson.M{"message": "Goal updated successfully"})
}

// DeleteGoal handles deleting a goal
func (h *Handlers) DeleteGoal(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	collection := h.DB.DB.Collection("goals")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	result, err := collection.DeleteOne(ctx, bson.M{"_id": id})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if result.DeletedCount == 0 {
		http.Error(w, "Goal not found", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(bson.M{"message": "Goal deleted successfully"})
}