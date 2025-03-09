package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// MongoDB connection string
const mongoURI = "mongodb+srv://rizamertyagci:mjRaNbCTHFdmDrJR@cluster0.niiiw.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

var client *mongo.Client
var database *mongo.Database

// Define models that match the Swift models
type User struct {
	ID        primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Name      string             `json:"name" bson:"name"`
	CreatedAt time.Time          `json:"createdAt" bson:"createdAt"`
}

type MoodHistoryEntry struct {
	ID     primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Mood   string             `json:"mood" bson:"mood"`
	Date   time.Time          `json:"date" bson:"date"`
	UserID primitive.ObjectID `json:"userId" bson:"userId"`
}

type Goal struct {
	ID          primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Title       string             `json:"title" bson:"title"`
	Type        string             `json:"type" bson:"type"`
	TargetDate  *time.Time         `json:"targetDate,omitempty" bson:"targetDate,omitempty"`
	IsCompleted bool               `json:"isCompleted" bson:"isCompleted"`
	CreatedAt   time.Time          `json:"createdAt" bson:"createdAt"`
	UserID      primitive.ObjectID `json:"userId" bson:"userId"`
}

type WellnessTip struct {
	ID        primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Content   string             `json:"content" bson:"content"`
	Category  string             `json:"category" bson:"category"`
	CreatedAt time.Time          `json:"createdAt" bson:"createdAt"`
}

type Affirmation struct {
	ID        primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Content   string             `json:"content" bson:"content"`
	CreatedAt time.Time          `json:"createdAt" bson:"createdAt"`
}

type Message struct {
	ID         primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Content    string             `json:"content" bson:"content"`
	IsFromUser bool               `json:"isFromUser" bson:"isFromUser"`
	Timestamp  time.Time          `json:"timestamp" bson:"timestamp"`
	UserID     primitive.ObjectID `json:"userId" bson:"userId"`
}

type UserSettings struct {
	ID                   primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	NotificationsEnabled bool               `json:"notificationsEnabled" bson:"notificationsEnabled"`
	DarkModeEnabled      bool               `json:"darkModeEnabled" bson:"darkModeEnabled"`
	ReminderTime         time.Time          `json:"reminderTime" bson:"reminderTime"`
	LanguageCode         string             `json:"languageCode" bson:"languageCode"`
	UserID               primitive.ObjectID `json:"userId" bson:"userId"`
}

type Meditation struct {
	ID          primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Title       string             `json:"title" bson:"title"`
	Description string             `json:"description" bson:"description"`
	Duration    int                `json:"duration" bson:"duration"`
	Type        string             `json:"type" bson:"type"`
	ImageName   string             `json:"imageName" bson:"imageName"`
}

func init() {
	// Create a context with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// Connect to MongoDB
	var err error
	clientOptions := options.Client().ApplyURI(mongoURI)
	client, err = mongo.Connect(ctx, clientOptions)
	if err != nil {
		log.Fatal(err)
	}

	// Check the connection
	err = client.Ping(ctx, nil)
	if err != nil {
		log.Fatal(err)
	}

	// Set the database
	database = client.Database("wellnessAI")

	// Create indexes for better performance
	createIndexes(ctx)

	// Initialize collections with default data
	initializeCollections(ctx)

	fmt.Println("Connected to MongoDB and initialized collections!")
}

func createIndexes(ctx context.Context) {
	// Create index for users
	userCollection := database.Collection("users")
	_, err := userCollection.Indexes().CreateOne(ctx, mongo.IndexModel{
		Keys:    bson.D{{Key: "name", Value: 1}},
		Options: options.Index().SetUnique(false),
	})
	if err != nil {
		log.Println("Error creating user index:", err)
	}

	// Create index for mood history
	moodCollection := database.Collection("moodHistory")
	_, err = moodCollection.Indexes().CreateOne(ctx, mongo.IndexModel{
		Keys: bson.D{{Key: "userId", Value: 1}, {Key: "date", Value: -1}},
	})
	if err != nil {
		log.Println("Error creating mood history index:", err)
	}

	// Create index for goals
	goalCollection := database.Collection("goals")
	_, err = goalCollection.Indexes().CreateOne(ctx, mongo.IndexModel{
		Keys: bson.D{{Key: "userId", Value: 1}},
	})
	if err != nil {
		log.Println("Error creating goals index:", err)
	}

	// Create index for messages
	messageCollection := database.Collection("messages")
	_, err = messageCollection.Indexes().CreateOne(ctx, mongo.IndexModel{
		Keys: bson.D{{Key: "userId", Value: 1}, {Key: "timestamp", Value: -1}},
	})
	if err != nil {
		log.Println("Error creating messages index:", err)
	}
}

func initializeCollections(ctx context.Context) {
	// Initialize wellness tips collection if empty
	tipCollection := database.Collection("wellnessTips")

	// Check if collection is empty
	count, err := tipCollection.CountDocuments(ctx, bson.M{})
	if err != nil {
		log.Println("Error counting wellness tips:", err)
	}

	if count == 0 {
		fmt.Println("Initializing wellness tips collection...")

		// Sample wellness tips
		tips := []interface{}{
			WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Focus on one goal every day. Small steps lead to big results.",
				Category:  "Motivation",
				CreatedAt: time.Now(),
			},
			WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Take a small step today toward realizing your dreams.",
				Category:  "Motivation",
				CreatedAt: time.Now(),
			},
			WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Failures are learning opportunities, embrace them.",
				Category:  "Motivation",
				CreatedAt: time.Now(),
			},
			WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Try to meditate for at least 10 minutes every day.",
				Category:  "Mindfulness",
				CreatedAt: time.Now(),
			},
			WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "When you're struggling, focus on your breath and take a few deep breaths.",
				Category:  "Mindfulness",
				CreatedAt: time.Now(),
			},
			WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Be kind to yourself, focus on progress rather than seeking perfection.",
				Category:  "SelfCare",
				CreatedAt: time.Now(),
			},
			WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Spend at least 30 minutes in nature every day.",
				Category:  "SelfCare",
				CreatedAt: time.Now(),
			},
			WellnessTip{
				ID:        primitive.NewObjectID(),
				Content:   "Be grateful for three things you do every day.",
				Category:  "Positivity",
				CreatedAt: time.Now(),
			},
			WellnessTip{
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

	// Initialize meditations collection if empty
	meditationCollection := database.Collection("meditations")

	count, err = meditationCollection.CountDocuments(ctx, bson.M{})
	if err != nil {
		log.Println("Error counting meditations:", err)
	}

	if count == 0 {
		fmt.Println("Initializing meditations collection...")

		// Sample meditations
		meditations := []interface{}{
			Meditation{
				ID:          primitive.NewObjectID(),
				Title:       "Morning Focus",
				Description: "A short meditation to start your day with energy",
				Duration:    5,
				Type:        "Focus",
				ImageName:   "sunrise.fill",
			},
			Meditation{
				ID:          primitive.NewObjectID(),
				Title:       "Deep Focus",
				Description: "Concentration-enhancing meditation before work",
				Duration:    10,
				Type:        "Focus",
				ImageName:   "lightbulb.fill",
			},
			Meditation{
				ID:          primitive.NewObjectID(),
				Title:       "Peaceful Sleep",
				Description: "Bedtime meditation for restful sleep",
				Duration:    10,
				Type:        "Sleep",
				ImageName:   "moon.zzz.fill",
			},
			Meditation{
				ID:          primitive.NewObjectID(),
				Title:       "Anxiety Reduction",
				Description: "Breathing techniques for calming anxiety",
				Duration:    8,
				Type:        "Anxiety",
				ImageName:   "waveform.path",
			},
			Meditation{
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

	// Initialize affirmations collection if empty
	affirmationCollection := database.Collection("affirmations")

	count, err = affirmationCollection.CountDocuments(ctx, bson.M{})
	if err != nil {
		log.Println("Error counting affirmations:", err)
	}

	if count == 0 {
		fmt.Println("Initializing affirmations collection...")

		// Sample affirmations
		affirmations := []interface{}{
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am valuable and deserve to be loved.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "Every day, in every way, I am getting better and stronger.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I have the power to overcome challenges.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I can change my life in a positive way.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am good enough and I accept myself as I am.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I feel grateful for today and every day.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I have the power to create my own happiness.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I radiate positive energy and attract positive energy.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am at peace.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I love myself more each day.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am the architect of my life and make positive choices.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I am fully present here and now, enjoying the moment.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "My worth is determined by who I am, not by my achievements.",
				CreatedAt: time.Now(),
			},
			Affirmation{
				ID:        primitive.NewObjectID(),
				Content:   "I approach myself with compassion and understanding.",
				CreatedAt: time.Now(),
			},
			Affirmation{
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

// User APIs
func createUser(w http.ResponseWriter, r *http.Request) {
	var user User
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	user.CreatedAt = time.Now()
	user.ID = primitive.NewObjectID()

	collection := database.Collection("users")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	result, err := collection.InsertOne(ctx, user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	user.ID = result.InsertedID.(primitive.ObjectID)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

func getUser(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	var user User
	collection := database.Collection("users")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	err = collection.FindOne(ctx, bson.M{"_id": id}).Decode(&user)
	if err != nil {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

func updateUser(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	var user User
	err = json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	collection := database.Collection("users")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	update := bson.M{
		"$set": bson.M{
			"name": user.Name,
		},
	}

	result := collection.FindOneAndUpdate(ctx, bson.M{"_id": id}, update, options.FindOneAndUpdate().SetReturnDocument(options.After))
	if result.Err() != nil {
		http.Error(w, result.Err().Error(), http.StatusInternalServerError)
		return
	}

	if err = result.Decode(&user); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

// Mood History APIs
func logMood(w http.ResponseWriter, r *http.Request) {
	var moodEntry MoodHistoryEntry
	err := json.NewDecoder(r.Body).Decode(&moodEntry)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	moodEntry.ID = primitive.NewObjectID()
	if moodEntry.Date.IsZero() {
		moodEntry.Date = time.Now()
	}

	collection := database.Collection("moodHistory")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Check if entry for this date already exists
	filter := bson.M{
		"userId": moodEntry.UserID,
		"date": bson.M{
			"$gte": truncateToDay(moodEntry.Date),
			"$lt":  truncateToDay(moodEntry.Date).Add(24 * time.Hour),
		},
	}

	var existingEntry MoodHistoryEntry
	err = collection.FindOne(ctx, filter).Decode(&existingEntry)
	if err == nil {
		// Entry exists, update it
		update := bson.M{
			"$set": bson.M{
				"mood": moodEntry.Mood,
				"date": moodEntry.Date,
			},
		}
		result, err := collection.UpdateOne(ctx, bson.M{"_id": existingEntry.ID}, update)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		if result.ModifiedCount == 0 {
			http.Error(w, "Failed to update mood entry", http.StatusInternalServerError)
			return
		}

		moodEntry.ID = existingEntry.ID
	} else {
		// Insert new entry
		result, err := collection.InsertOne(ctx, moodEntry)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		moodEntry.ID = result.InsertedID.(primitive.ObjectID)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(moodEntry)
}

func getUserMoodHistory(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	userID, err := primitive.ObjectIDFromHex(params["userId"])
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	collection := database.Collection("moodHistory")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Get entries for the last 7 days
	filter := bson.M{
		"userId": userID,
		"date": bson.M{
			"$gte": time.Now().AddDate(0, 0, -7),
		},
	}

	cursor, err := collection.Find(ctx, filter, options.Find().SetSort(bson.M{"date": -1}))
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var moodHistory []MoodHistoryEntry
	if err = cursor.All(ctx, &moodHistory); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(moodHistory)
}

// Goals APIs
func createGoal(w http.ResponseWriter, r *http.Request) {
	var goal Goal
	err := json.NewDecoder(r.Body).Decode(&goal)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	goal.ID = primitive.NewObjectID()
	goal.CreatedAt = time.Now()

	collection := database.Collection("goals")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	result, err := collection.InsertOne(ctx, goal)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	goal.ID = result.InsertedID.(primitive.ObjectID)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(goal)
}

func getUserGoals(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	userID, err := primitive.ObjectIDFromHex(params["userId"])
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	collection := database.Collection("goals")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	filter := bson.M{"userId": userID}
	cursor, err := collection.Find(ctx, filter)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var goals []Goal
	if err = cursor.All(ctx, &goals); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(goals)
}

func updateGoal(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	var goal Goal
	err = json.NewDecoder(r.Body).Decode(&goal)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	collection := database.Collection("goals")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	update := bson.M{
		"$set": bson.M{
			"title":       goal.Title,
			"type":        goal.Type,
			"targetDate":  goal.TargetDate,
			"isCompleted": goal.IsCompleted,
		},
	}

	result, err := collection.UpdateOne(ctx, bson.M{"_id": id}, update)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if result.ModifiedCount == 0 {
		http.Error(w, "Goal not found or not modified", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(bson.M{"message": "Goal updated successfully"})
}

func deleteGoal(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := primitive.ObjectIDFromHex(params["id"])
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	collection := database.Collection("goals")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	result, err := collection.DeleteOne(ctx, bson.M{"_id": id})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if result.DeletedCount == 0 {
		http.Error(w, "Goal not found", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(bson.M{"message": "Goal deleted successfully"})
}

// Messages APIs
func saveMessages(w http.ResponseWriter, r *http.Request) {
	var messages []Message
	err := json.NewDecoder(r.Body).Decode(&messages)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	if len(messages) == 0 {
		http.Error(w, "No messages provided", http.StatusBadRequest)
		return
	}

	collection := database.Collection("messages")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Convert []Message to []interface{} for bulk insert
	var documents []interface{}
	for i := range messages {
		if messages[i].ID.IsZero() {
			messages[i].ID = primitive.NewObjectID()
		}
		if messages[i].Timestamp.IsZero() {
			messages[i].Timestamp = time.Now()
		}
		documents = append(documents, messages[i])
	}

	result, err := collection.InsertMany(ctx, documents)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(bson.M{"insertedCount": len(result.InsertedIDs)})
}

func getUserMessages(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	userID, err := primitive.ObjectIDFromHex(params["userId"])
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	collection := database.Collection("messages")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	filter := bson.M{"userId": userID}
	opts := options.Find().SetSort(bson.M{"timestamp": 1})
	cursor, err := collection.Find(ctx, filter, opts)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var messages []Message
	if err = cursor.All(ctx, &messages); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(messages)
}

// User Settings APIs
func saveUserSettings(w http.ResponseWriter, r *http.Request) {
	var settings UserSettings
	err := json.NewDecoder(r.Body).Decode(&settings)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	collection := database.Collection("userSettings")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Check if settings already exist for this user
	filter := bson.M{"userId": settings.UserID}
	var existingSettings UserSettings
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

func getUserSettings(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	userID, err := primitive.ObjectIDFromHex(params["userId"])
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	collection := database.Collection("userSettings")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	var settings UserSettings
	err = collection.FindOne(ctx, bson.M{"userId": userID}).Decode(&settings)
	if err != nil {
		// Return default settings if none exist
		defaultSettings := UserSettings{
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

// Meditations APIs
func getAllMeditations(w http.ResponseWriter, r *http.Request) {
	collection := database.Collection("meditations")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var meditations []Meditation
	if err = cursor.All(ctx, &meditations); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(meditations)
}

func getMeditationsByType(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	meditationType := params["type"]

	collection := database.Collection("meditations")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	filter := bson.M{"type": meditationType}
	cursor, err := collection.Find(ctx, filter)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var meditations []Meditation
	if err = cursor.All(ctx, &meditations); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(meditations)
}

// Wellness Tips APIs
func getAllWellnessTips(w http.ResponseWriter, r *http.Request) {
	collection := database.Collection("wellnessTips")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var tips []WellnessTip
	if err = cursor.All(ctx, &tips); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tips)
}

func getWellnessTipsByCategory(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	category := params["category"]

	collection := database.Collection("wellnessTips")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	filter := bson.M{"category": category}
	cursor, err := collection.Find(ctx, filter)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var tips []WellnessTip
	if err = cursor.All(ctx, &tips); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tips)
}

// Affirmations APIs
func getAllAffirmations(w http.ResponseWriter, r *http.Request) {
	collection := database.Collection("affirmations")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)

	var affirmations []Affirmation
	if err = cursor.All(ctx, &affirmations); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(affirmations)
}

func getRandomAffirmation(w http.ResponseWriter, r *http.Request) {
	collection := database.Collection("affirmations")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Get count of all affirmations
	count, err := collection.CountDocuments(ctx, bson.M{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if count == 0 {
		http.Error(w, "No affirmations found", http.StatusNotFound)
		return
	}

	// Get a random number between 0 and count-1
	skip := rand.Int63n(count)

	// Find one random affirmation
	opts := options.FindOne().SetSkip(skip)
	var affirmation Affirmation
	err = collection.FindOne(ctx, bson.M{}, opts).Decode(&affirmation)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(affirmation)
}

// Helper function to truncate time to start of day
func truncateToDay(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, t.Location())
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	router := mux.NewRouter()

	// User routes
	router.HandleFunc("/api/users", createUser).Methods("POST")
	router.HandleFunc("/api/users/{id}", getUser).Methods("GET")
	router.HandleFunc("/api/users/{id}", updateUser).Methods("PUT")

	// Mood history routes
	router.HandleFunc("/api/mood", logMood).Methods("POST")
	router.HandleFunc("/api/mood/user/{userId}", getUserMoodHistory).Methods("GET")

	// Goals routes
	router.HandleFunc("/api/goals", createGoal).Methods("POST")
	router.HandleFunc("/api/goals/user/{userId}", getUserGoals).Methods("GET")
	router.HandleFunc("/api/goals/{id}", updateGoal).Methods("PUT")
	router.HandleFunc("/api/goals/{id}", deleteGoal).Methods("DELETE")

	// Messages routes
	router.HandleFunc("/api/messages", saveMessages).Methods("POST")
	router.HandleFunc("/api/messages/user/{userId}", getUserMessages).Methods("GET")

	// User settings routes
	router.HandleFunc("/api/settings", saveUserSettings).Methods("POST")
	router.HandleFunc("/api/settings/user/{userId}", getUserSettings).Methods("GET")

	// Meditation routes
	router.HandleFunc("/api/meditations", getAllMeditations).Methods("GET")
	router.HandleFunc("/api/meditations/type/{type}", getMeditationsByType).Methods("GET")

	// Wellness tips routes
	router.HandleFunc("/api/tips", getAllWellnessTips).Methods("GET")
	router.HandleFunc("/api/tips/category/{category}", getWellnessTipsByCategory).Methods("GET")

	// Affirmations routes
	router.HandleFunc("/api/affirmations", getAllAffirmations).Methods("GET")
	router.HandleFunc("/api/affirmations/random", getRandomAffirmation).Methods("GET")

	// Create a basic API health endpoint
	router.HandleFunc("/api/health", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(map[string]bool{"ok": true})
	}).Methods("GET")

	// Start server
	fmt.Printf("Server running on :%s\n", port)
	log.Fatal(http.ListenAndServe(":"+port, router))
}
