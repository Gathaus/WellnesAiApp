package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// Meditation represents a meditation exercise
type Meditation struct {
	ID          primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Title       string             `json:"title" bson:"title"`
	Description string             `json:"description" bson:"description"`
	Duration    int                `json:"duration" bson:"duration"`
	Type        string             `json:"type" bson:"type"`
	ImageName   string             `json:"imageName" bson:"imageName"`
}