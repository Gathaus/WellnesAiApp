package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

// WellnessTip represents a wellness tip in the system
type WellnessTip struct {
	ID        primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Content   string             `json:"content" bson:"content"`
	Category  string             `json:"category" bson:"category"`
	CreatedAt time.Time          `json:"createdAt" bson:"createdAt"`
}