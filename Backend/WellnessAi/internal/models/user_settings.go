package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

// UserSettings represents user preferences
type UserSettings struct {
	ID                   primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	NotificationsEnabled bool               `json:"notificationsEnabled" bson:"notificationsEnabled"`
	DarkModeEnabled      bool               `json:"darkModeEnabled" bson:"darkModeEnabled"`
	ReminderTime         time.Time          `json:"reminderTime" bson:"reminderTime"`
	LanguageCode         string             `json:"languageCode" bson:"languageCode"`
	UserID               primitive.ObjectID `json:"userId" bson:"userId"`
}