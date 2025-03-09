package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Affirmation represents a positive affirmation
type Affirmation struct {
	ID        primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Content   string             `json:"content" bson:"content"`
	CreatedAt time.Time          `json:"createdAt" bson:"createdAt"`
}