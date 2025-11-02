import SwiftUI

struct LoginScreen: View {
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var store: AuthStore
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
            SecureField("Password", text: $viewModel.password)

            if store.isLoading {
                ProgressView()
            } else {
                Button("Login") {
                    viewModel.login()
                }
                .disabled(viewModel.isButtonDisabled)
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
