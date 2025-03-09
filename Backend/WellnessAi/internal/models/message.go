package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Message represents a chat message between user and system
type Message struct {
	ID         primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Content    string             `json:"content" bson:"content"`
	IsFromUser bool               `json:"isFromUser" bson:"isFromUser"`
	Timestamp  time.Time          `json:"timestamp" bson:"timestamp"`
	UserID     primitive.ObjectID `json:"userId" bson:"userId"`
}