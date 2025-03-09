package database

import (
	"context"
	"fmt"
	"log"
	"math/rand"
	"time"

	"WellnessAi/internal/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Helper function to truncate time to start of day
func TruncateToDay(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, t.Location())
}

// CompleteAffirmationsInitialization completes the initialization of affirmations collection
func (d *Database) initializeAffirmations(ctx context.Context) {
	affirmationCollection := d.DB.Collection("affirmations")

	count, err := affirmationCollection.CountDocuments(ctx, bson.M{})
	if err != nil {
		log.Println("Error counting affirmations:", err)
	}

	if count == 0 {
		fmt.Println("Initializing affirmations collection...")

		// Sample affirmations
		affirmations := []interface{}{
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am valuable and deserve to be loved.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "Every day, in every way, I am getting better and stronger.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I have the power to overcome challenges.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I can change my life in a positive way.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am good enough and I accept myself as I am.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I feel grateful for today and every day.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I have the power to create my own happiness.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I radiate positive energy and attract positive energy.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am at peace.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I love myself more each day.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am the architect of my life and make positive choices.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am fully present here and now, enjoying the moment.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "My worth is determined by who I am, not by my achievements.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I approach myself with compassion and understanding.",
				CreatedAt: time.Now(),
			},
			models.Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "Every challenge strengthens and grows me.",
				CreatedAt: time.Now(),
			},
		}

		_, err := affirmationCollection.InsertMany(ctx, affirmations)
		if err != nil {
			log.Println("Error inserting affirmations:", err)
		} else {
			fmt.Println("Successfully initialized affirmations collection")
		}
	}
}

// GetRandomAffirmation gets a random affirmation from the database
func (d *Database) GetRandomAffirmation(ctx context.Context) (models.Affirmation, error) {
	affirmationCollection := d.DB.Collection("affirmations")

	// Get count of all affirmations
	count, err := affirmationCollection.CountDocuments(ctx, bson.M{})
	if err != nil {
		return models.Affirmation{}, err
	}

	if count == 0 {
		return models.Affirmation{}, fmt.Errorf("no affirmations found")
	}

	// Get a random number between 0 and count-1
	skip := rand.Int63n(count)

	// Find one random affirmation
	opts := options.FindOne().SetSkip(skip)
	var affirmation models.Affirmation
	err = affirmationCollection.FindOne(ctx, bson.M{}, opts).Decode(&affirmation)
	if err != nil {
		return models.Affirmation{}, err
	}

	return affirmation, nil
}