package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Goal represents a user's wellness goal
type Goal struct {
	ID          primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Title       string             `json:"title" bson:"title"`
	Type        string             `json:"type" bson:"type"`
	TargetDate  *time.Time         `json:"targetDate,omitempty" bson:"targetDate,omitempty"`
	IsCompleted bool               `json:"isCompleted" bson:"isCompleted"`
	CreatedAt   time.Time          `json:"createdAt" bson:"createdAt"`
	UserID      primitive.ObjectID `json:"userId" bson:"userId"`
}