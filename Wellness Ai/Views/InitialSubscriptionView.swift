import SwiftUI

struct InitialSubscriptionView: View {
    @EnvironmentObject var viewModel: WellnessViewModel
    @AppStorage("hasSeenSubscription") private var hasSeenSubscription = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: 25) {
                    // App logo
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Text("W")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                    
                    Text("WellnessAI")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Your Personal Wellness Assistant")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 30)
                    
                    // Premium features
                    VStack(spacing: 20) {
                        Text("Premium Features")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        FeatureRow(icon: "brain.head.profile", title: "Advanced Meditations", description: "Access to 80+ meditation tracks")
                        FeatureRow(icon: "chart.bar.fill", title: "Detailed Analytics", description: "Track your wellness journey")
                        FeatureRow(icon: "person.fill.checkmark", title: "Personalized Insights", description: "AI-powered recommendations")
                        FeatureRow(icon: "heart.text.square.fill", title: "Unlimited Inspirations", description: "New content daily")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        // Subscribe button
                        Button(action: {
                            viewModel.updatePremiumStatus(true)
                            hasSeenSubscription = true
                        }) {
                            Text("Subscribe Now")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(15)
                                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        // Free trial button
                        Button(action: {
                            viewModel.startFreeTrial()
                            hasSeenSubscription = true
                        }) {
                            Text("Start 3-Day Free Trial")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        Text("Trial automatically ends after 3 days")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 5)
                    }
                    .padding()
                    
                    // Price information
                    Text("$4.99/month or $39.99/year after trial ends")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 20)
                    
                    // Terms and privacy
                    HStack(spacing: 20) {
                        Button(action: {
                            // Show terms
                        }) {
                            Text("Terms of Service")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .underline()
                        }
                        
                        Button(action: {
                            // Show privacy policy
                        }) {
                            Text("Privacy Policy")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .underline()
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}
