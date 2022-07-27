//
//  LoginView.swift
//
//  Created on 19/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    @EnvironmentObject var settings: Settings

    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showingLoading = false

    private let keychain = KeychainWrapper.shared

    private enum Dimensions {
        static let topInputFieldPadding: CGFloat = 32.0
        static let buttonPadding: CGFloat = 24.0
        static let topPadding: CGFloat = 48.0
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        Group {
            if showingLoading {
                LoadingIndicatorView(isAnimating: $showingLoading,
                    style: .large)
                    .padding(.top, Dimensions.topPadding)

            } else {
                VStack(spacing: .zero) {
                    Color.inactiveBar.frame(height: 0.5)

                    KeyboardControllingScrollView {
                        VStack(spacing: Dimensions.padding) {
                            Image("ofish-blue")
                                .padding(.top, Dimensions.topPadding)

                            ZStack(alignment: .trailing) {
                                InputField(title: "Email/Username",
                                           text: self.$username,
                                           tag: 0,
                                           autocapitalizationType: .none,
                                           autocorrectionType: .no,
                                           keyboardType: .emailAddress)

                                Button(action: self.getStoredCredentials) {
                                    Image(systemName: self.keychain.getPictureName())
                                        .foregroundColor(.removeAction)
                                }
                            }
                                .padding(.top, Dimensions.topInputFieldPadding)
                                .padding(.bottom, Dimensions.padding)

                            InputField(title: "Password",
                                       text: self.$password,
                                       tag: 1,
                                       showingSecureField: true)

                            CallToActionButton(title: "Log In",
                                               action: {
                                                self.login(username: self.username, password: self.password)
                            })
                                .opacity(self.username.isEmpty || self.password.isEmpty ? 0.5 : 1.0)
                                .padding(.top, Dimensions.topInputFieldPadding)
                                .padding(.bottom, Dimensions.buttonPadding)

                            //TODO need to implement Forgot password
                            Button(action: { print("Forgot password") }) {
                                Text("Forgot Password?")
                                    .foregroundColor(.removeAction)
                                    .font(.subheadline)
                            }
                                .opacity(0) // TODO remove after implementing
                        }
                    }
                        .padding(.horizontal, Dimensions.padding)
                }
            }
        }
            .navigationBarBackButtonHidden(true)
            // TODO: These are needed to clear the bar after logging out – check
            // if there's a cleaner approach
            .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
            .navigationBarTitle(Text("Login"), displayMode: .inline)
            .alert(isPresented: Binding<Bool>(
                get: { !self.errorMessage.isEmpty },
                set: { _ in })) {
                Alert(title: Text("Login Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("Ok")) {
                        self.errorMessage = ""
                        self.password = ""
                    })
            }
    }

    private func login(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            return
        }
        showingLoading = true
        let credentials = Credentials.emailPassword(email: username, password: password)
        app.login(credentials: credentials) { result in
            self.showingLoading = false
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    print("Logged in as " + user.firstName + " " + user.lastName + " " + username)
                    self.settings.realmUser = user
                }
            case .failure(let error):
                print("Loggin error: \(error.localizedDescription)")
                self.errorMessage = "Invalid email or password"
            }
        }
    }

    private func getStoredCredentials() {
        let data = keychain.readCredentials()
        if let credentials = data.credentials {
            self.login(username: credentials.username, password: credentials.password)
        }

        if let error = data.error as? KeychainError {
            self.errorMessage = error.localizedDescription
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var settings = Settings()

    static var previews: some View {
        NavigationView {
            LoginView().environmentObject(settings)
        }
    }
}
