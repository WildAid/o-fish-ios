//
//  LoginView.swift
//
//  Created on 19/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode

    var loggedIn: Binding<Bool>

    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showingLoading = false

    private enum Dimensions {
        static let topInputFieldPadding: CGFloat = 32.0
        static let buttonPadding: CGFloat = 24.0
        static let topPadding: CGFloat = 48.0
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        VStack {
            if showingLoading {
                LoadingIndicatorView(isAnimating: $showingLoading,
                                     style: .large)
            } else {
                KeyboardControllingScrollView {
                    Group {
                        Image("ofish-blue")

                        ZStack(alignment: .trailing) {
                            InputField(title: "Email/Username",
                                text: self.$username)
                            //TODO need to implement Face id
                            Button(action: { print("Face id") }) {
                                Image(systemName: "faceid")
                                    .foregroundColor(.removeAction)
                            }
                                .opacity(0) // TODO remove after implementing
                        }
                            .padding(.top, Dimensions.topInputFieldPadding)

                        InputField(title: "Password",
                            text: self.$password,
                            showingSecureField: true)

                        CallToActionButton(title: "Log In",
                            action: self.login)
                            .opacity(self.username.isEmpty || self.password.isEmpty ? 0.5 : 1.0)
                            .padding(.top, Dimensions.topInputFieldPadding)
                            .padding(.bottom, Dimensions.buttonPadding)
                        //TODO need to implement Forgot password
                        Button(action: { print("Forgot password") }) {
                            Text("Forgot Password?")
                                .foregroundColor(.removeAction)
                        }
                            .opacity(0) // TODO remove after implementing
                    }
                }
            }
        }
            .padding(.top, Dimensions.topPadding)
            .padding(.horizontal, Dimensions.padding)
            .navigationBarBackButtonHidden(true)
            // TODO: These are needed to clear the bar after logging out – check
            // if there's a cleaner approach
            .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
            .navigationBarTitle(Text("Login"), displayMode: .inline)
            .alert(isPresented: Binding<Bool>(
                get: { return !self.errorMessage.isEmpty },
                set: { _ in })) {
                Alert(title: Text("Error"),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("Ok")) {
                    self.errorMessage = ""
                    self.password = ""
                    })
        }
    }

    private func login() {
        if username.isEmpty || password.isEmpty {
            errorMessage = "Please write email and password"
            return
        }
        showingLoading = true
        RealmConnection.logIn( username: username, password: password) { result in
            self.showingLoading = false
            switch result {
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            case .success:
                print("Logged in")
                self.loggedIn.wrappedValue = true
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(loggedIn: .constant(true))
        }
    }
}
