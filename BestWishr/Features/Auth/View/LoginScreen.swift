import SwiftUI

struct LoginScreen: View {
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var store: AuthStore
    @State private var showRegister = false
    @State private var showForgotPassword = false
    @State private var isAnimating = false
    @State private var showFloatingIcons = false
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            FloatingIconsBackground(
                isAnimating: $isAnimating,
                showFloatingIcons: $showFloatingIcons
            )
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Spacer()
                    
                    AppLogoView(isAnimating: $isAnimating)
                    
                    TitleSection()
                    
                    Spacer()
                }
                .frame(maxHeight: 200)
                
                VStack(spacing: 0) {
                    LoginForm(
                        viewModel: viewModel,
                        store: store,
                        onSignUpTap: { showRegister = true },
                        onForgotPasswordTap: { showForgotPassword = true }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showRegister) {
            RegisterScreen()
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordScreen()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                isAnimating = true
            }
            withAnimation(.easeInOut(duration: 1.5).delay(0.5)) {
                showFloatingIcons = true
            }
        }
    }
}

#Preview("Login – Placeholder") {
    // Minimal placeholder preview to keep builds green while underlying types are unavailable
    VStack(spacing: 12) {
        Text("Login Preview Unavailable")
            .font(.headline)
        Text("Provide preview stubs for AuthViewModel and AuthStore or run the app.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        // Optional: a rough layout echo so designers can still see spacing
        VStack {
            TextField("Email", text: .constant(""))
            SecureField("Password", text: .constant(""))
            Button("Login") {}
                .disabled(true)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    .padding()
}
