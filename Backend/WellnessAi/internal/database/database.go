package database

import (
	"context"
	"fmt"
	"log"
	"time"

	"WellnessAi/internal/config"
	"WellnessAi/internal/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Database represents a MongoDB database connection
type Database struct {
	Client *mongo.Client
	DB     *mongo.Database
}

// Connect establishes a connection to MongoDB and returns a Database instance
func Connect() (*Database, error) {
	// Create a context with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// Connect to MongoDB
	clientOptions := options.Client().ApplyURI(config.MongoURI)
	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		return nil, err
	}

	// Check the connection
	err = client.Ping(ctx, nil)
	if err != nil {
		return nil, err
	}

	// Set the database
	db := client.Database(config.DatabaseName)

	// Create database instance
	database := &Database{
		Client: client,
		DB:     db,
	}

	// Create indexes for better performance
	database.createIndexes(ctx)

	// Initialize collections with default data
	database.initializeCollections(ctx)

	fmt.Println("Connected to MongoDB and initialized collections!")
	return database, nil
}

// createIndexes creates indexes for better query performance
func (d *Database) createIndexes(ctx context.Context) {
	// Create index for users
	userCollection := d.DB.Collection("users")
	_, err := userCollection.Indexes().CreateOne(ctx, mongo.IndexModel{
		Keys:    bson.D{{Key: "name", Value: 1}},
		Options: options.Index().SetUnique(false),
	})
	if err != nil {
		log.Println("Error creating user index:", err)
	}

	// Create index for mood history
	moodCollection := d.DB.Collection("moodHistory")
	_, err = moodCollection.Indexes().CreateOne(ctx, mongo.IndexModel{
		Keys: bson.D{{Key: "userId", Value: 1}, {Key: "date", Value: -1}},
	})
	if err != nil {
		log.Println("Error creating mood history index:", err)
	}

	// Create index for goals
	goalCollection := d.DB.Collection("goals")
	_, err = goalCollection.Indexes().CreateOne(ctx, mongo.IndexModel{
		Keys: bson.D{{Key: "userId", Value: 1}},
	})
	if err != nil {
		log.Println("Error creating goals index:", err)
	}

	// Create index for messages
	messageCollection := d.DB.Collection("messages")
	_, err = messageCollection.Indexes().CreateOne(ctx, mongo.IndexModel{
		Keys: bson.D{{Key: "userId", Value: 1}, {Key: "timestamp", Value: -1}},
	})
	if err != nil {
		log.Println("Error creating messages index:", err)
	}
}

// initializeCollections initializes collections with default data if they are empty
func (d *Database) initializeCollections(ctx context.Context) {
	// Initialize wellness tips collection if empty
	d.initializeWellnessTips(ctx)

	// Initialize meditations collection if empty
	d.initializeMeditations(ctx)

	// Initialize affirmations collection if empty
	d.initializeAffirmations(ctx)
}

// initializeWellnessTips initializes the wellness tips collection with default data
func (d *Database) initializeWellnessTips(ctx context.Context) {
	tipCollection := d.DB.Collection("wellnessTips")

	// Check if collection is empty
	count, err := tipCollection.CountDocuments(ctx, bson.M{})
	if err != nil {
		log.Println("Error counting wellness tips:", err)
	}

	if count == 0 {
		fmt.Println("Initializing wellness tips collection...")

		// Sample wellness tips
		tips := []interface{}{
			models.WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Focus on one goal every day. Small steps lead to big results.",
				Category:  "Motivation",
				CreatedAt: time.Now(),
			},
			models.WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Take a small step today toward realizing your dreams.",
				Category:  "Motivation",
				CreatedAt: time.Now(),
			},
			models.WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Failures are learning opportunities, embrace them.",
				Category:  "Motivation",
				CreatedAt: time.Now(),
			},
			models.WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Try to meditate for at least 10 minutes every day.",
				Category:  "Mindfulness",
				CreatedAt: time.Now(),
			},
			models.WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "When you're struggling, focus on your breath and take a few deep breaths.",
				Category:  "Mindfulness",
				CreatedAt: time.Now(),
			},
			models.WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Be kind to yourself, focus on progress rather than seeking perfection.",
				Category:  "SelfCare",
				CreatedAt: time.Now(),
			},
			models.WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Spend at least 30 minutes in nature every day.",
				Category:  "SelfCare",
				CreatedAt: time.Now(),
			},
			models.WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Be grateful for three things you do every day.",
				Category:  "Positivity",
				CreatedAt: time.Now(),
			},
			models.WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Enjoy the little moments that make you happy.",
				Category:  "Positivity",
				CreatedAt: time.Now(),
			},
		}

		_, err := tipCollection.InsertMany(ctx, tips)
		if err != nil {
			log.Println("Error inserting wellness tips:", err)
		} else {
			fmt.Println("Successfully initialized wellness tips collection")
		}
	}
}

// initializeMeditations initializes the meditations collection with default data
func (d *Database) initializeMeditations(ctx context.Context) {
	meditationCollection := d.DB.Collection("meditations")

	count, err := meditationCollection.CountDocuments(ctx, bson.M{})
	if err != nil {
		log.Println("Error counting meditations:", err)
	}

	if count == 0 {
		fmt.Println("Initializing meditations collection...")

		// Sample meditations
		meditations := []interface{}{
			models.Meditation{
				ID:          primitive.NewObjectID(),
				Title:       "Morning Focus",
				Description: "A short meditation to start your day with energy",
				Duration:    5,
				Type:        "Focus",
				ImageName:   "sunrise.fill",
			},
			models.Meditation{
				ID:          primitive.NewObjectID(),
				Title:       "Deep Focus",
				Description: "Concentration-enhancing meditation before work",
				Duration:    10,
				Type:        "Focus",
				ImageName:   "lightbulb.fill",
			},
			models.Meditation{
				ID:          primitive.NewObjectID(),
				Title:       "Peaceful Sleep",
				Description: "Bedtime meditation for restful sleep",
				Duration:    10,
				Type:        "Sleep",
				ImageName:   "moon.zzz.fill",
			},
			models.Meditation{
				ID:          primitive.NewObjectID(),
				Title:       "Anxiety Reduction",
				Description: "Breathing techniques for calming anxiety",
				Duration:    8,
				Type:        "Anxiety",
				ImageName:   "waveform.path",
			},
			models.Meditation{
				ID:          primitive.NewObjectID(),
				Title:       "Inner Peace",
				Description: "Meditation to help find inner peace",
				Duration:    15,
				Type:        "Calm",
				ImageName:   "leaf.fill",
			},
		}

		_, err := meditationCollection.InsertMany(ctx, meditations)
		if err != nil {
			log.Println("Error inserting meditations:", err)
		} else {
			fmt.Println("Successfully initialized meditations collection")
		}
	}
}

// initializeAffirmations initializes the affirmations collection with default data
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