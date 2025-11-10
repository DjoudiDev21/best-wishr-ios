import SwiftUI

struct RegisterScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @State private var isLoading = false
    @State private var isAnimating = false
    @State private var formSlideOffset: CGFloat = 300
    
    private var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6 &&
        agreeToTerms &&
        email.contains("@")
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section with uniform background
                        VStack(spacing: 24) {
                            Spacer()
                            
                            // App Logo
                            Image(systemName: "party.popper.fill")
                                .font(.system(size: 70))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.blue, Color.purple, Color.pink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .symbolRenderingMode(.hierarchical)
                                .scaleEffect(isAnimating ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                            
                            // Welcome Text
                            VStack(spacing: 8) {
                                Text("Join the Celebration!")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("Create memories that last forever")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                            }
                            
                            Spacer()
                        }
                        .frame(height: geometry.size.height * 0.25)
                        .frame(maxWidth: .infinity)
                        
                        // Form Section with slide animation
                        VStack(spacing: 20) {
                            VStack(spacing: 16) {
                                // Name Fields Row
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("First Name")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                        
                                        TextField("First name", text: $firstName)
                                            .textFieldStyle(CustomTextFieldStyle())
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Last Name")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                        
                                        TextField("Last name", text: $lastName)
                                            .textFieldStyle(CustomTextFieldStyle())
                                    }
                                }
                                
                                // Email Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Email")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                    
                                    TextField("Enter your email", text: $email)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                
                                // Password Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Password")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                    
                                    SecureField("Enter your password", text: $password)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                
                                // Confirm Password Field
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Confirm Password")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                    
                                    SecureField("Confirm your password", text: $confirmPassword)
                                        .textFieldStyle(CustomTextFieldStyle())
                                    
                                    if !confirmPassword.isEmpty && password != confirmPassword {
                                        Text("Passwords don't match")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                // Password Requirements
                                if !password.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Password must contain:")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        HStack {
                                            Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(password.count >= 6 ? .green : .gray)
                                                .font(.caption)
                                            Text("At least 6 characters")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                    }
                                    .padding(.top, 4)
                                }
                            }
                            
                            // Terms and Conditions
                            HStack(alignment: .top, spacing: 12) {
                                Button(action: {
                                    agreeToTerms.toggle()
                                }) {
                                    Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                        .foregroundColor(agreeToTerms ? .pink : .gray)
                                        .font(.title3)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("I agree to the **Terms of Service** and **Privacy Policy**")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            .padding(.top, 8)
                            
                            // Register Button with celebration theme
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    registerUser()
                                }
                            }) {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: "party.popper.fill")
                                            .font(.title3)
                                        Text("Join the Magic!")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    isFormValid ? 
                                    LinearGradient(
                                        colors: [Color.blue, Color.purple, Color.pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ) : 
                                    LinearGradient(
                                        colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .shadow(color: isFormValid ? .purple.opacity(0.4) : .clear, radius: 10, x: 0, y: 5)
                            }
                            .disabled(!isFormValid || isLoading)
                            .scaleEffect(isFormValid ? 1.0 : 0.95)
                            .animation(.easeInOut(duration: 0.2), value: isFormValid)
                            .padding(.top, 8)
                            
                            // Sign In Link
                            HStack {
                                Text("Already have an account?")
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Button("Sign In") {
                                    dismiss()
                                }
                                .fontWeight(.medium)
                                .foregroundColor(.pink)
                            }
                            .font(.subheadline)
                            .padding(.top, 16)
                        }
                        .padding(.horizontal, 32)
                        .frame(minHeight: geometry.size.height * 0.75)
                        .offset(y: formSlideOffset)
                        .animation(.easeOut(duration: 0.8), value: formSlideOffset)
                    }
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.8),
                        Color.purple.opacity(0.9),
                        Color.pink.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.pink)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                isAnimating = true
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
                formSlideOffset = 0
            }
        }
    }
    
    private func registerUser() {
        isLoading = true
        
        // TODO: Implement registration logic when backend is ready
        // For now, simulate a network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            // Show success message or navigate to next screen
            print("Registration attempted with:")
            print("Name: \(firstName) \(lastName)")
            print("Email: \(email)")
            dismiss()
        }
    }
}

#Preview {
    RegisterScreen()
}
