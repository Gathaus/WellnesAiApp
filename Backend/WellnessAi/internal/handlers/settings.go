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

// SaveUserSettings handles saving user settings
func (h *Handlers) SaveUserSettings(w http.ResponseWriter, r *http.Request) {
	var settings models.UserSettings
	err := json.NewDecoder(r.Body).Decode(&settings)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	collection := h.DB.DB.Collection("userSettings")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	// Check if settings already exist for this user
	filter := bson.M{"userId": settings.UserID}
	var existingSettings models.UserSettings
	err = collection.FindOne(ctx, filter).Decode(&existingSettings)

	if err == nil {
		// Settings exist, update them
		update := bson.M{
			"$set": bson.M{
				"notificationsEnabled": settings.NotificationsEnabled,
				"darkModeEnabled":      settings.DarkModeEnabled,
				"reminderTime":         settings.ReminderTime,
				"languageCode":         settings.LanguageCode,
			},
		}

		result, err := collection.UpdateOne(ctx, filter, update)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		if result.ModifiedCount == 0 {
			http.Error(w, "Failed to update settings", http.StatusInternalServerError)
			return
		}

		settings.ID = existingSettings.ID
	} else {
		// Settings don't exist, create new
		settings.ID = primitive.NewObjectID()
		result, err := collection.InsertOne(ctx, settings)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		settings.ID = result.InsertedID.(primitive.ObjectID)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(settings)
}

// GetUserSettings handles retrieving a user's settings
func (h *Handlers) GetUserSettings(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	userID, err := primitive.ObjectIDFromHex(params["userId"])
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	collection := h.DB.DB.Collection("userSettings")
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(config.ContextTimeout)*time.Second)
	defer cancel()

	var settings models.UserSettings
	err = collection.FindOne(ctx, bson.M{"userId": userID}).Decode(&settings)
	if err != nil {
		// Return default settings if none exist
		defaultSettings := models.UserSettings{
			NotificationsEnabled: true,
			DarkModeEnabled:      false,
			ReminderTime:         time.Date(0, 0, 0, 9, 0, 0, 0, time.UTC),
			LanguageCode:         "en",
			UserID:               userID,
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(defaultSettings)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(settings)
}