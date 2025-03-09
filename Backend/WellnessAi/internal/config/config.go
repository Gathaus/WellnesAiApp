package config

// Application constants
const (
	// DefaultPort is the default port for the server if not specified in environment
	DefaultPort = "8080"

	// MongoURI is the connection string for MongoDB
	MongoURI = "mongodb+srv://rizamertyagci:mjRaNbCTHFdmDrJR@cluster0.niiiw.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

	// DatabaseName is the name of the MongoDB database
	DatabaseName = "wellnessAI"

	// ContextTimeout is the default timeout for database operations
	ContextTimeout = 5 // seconds
)