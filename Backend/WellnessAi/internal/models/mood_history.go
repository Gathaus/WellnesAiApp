package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

// MoodHistoryEntry represents a user's mood at a specific time
type MoodHistoryEntry struct {
	ID     primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Mood   string             `json:"mood" bson:"mood"`
	Date   time.Time          `json:"date" bson:"date"`
	UserID primitive.ObjectID `json:"userId" bson:"userId"`
}