//
//  Onboarding.swift
//  Little Lemon
//
//  Created by Joaquin Tome on 18/2/23.
//

import SwiftUI


let kFirstName = "first_name_key"
let kLastName = "last_name_key"
let kEmail = "email_key"
let kIsLoggedIn = "isLoggedIn"

struct Onboarding: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Register to Little Lemon").font(.title).bold()
                Spacer().frame(height: 30)
                NavigationLink(
                    destination: Home().navigationBarBackButtonHidden(true),
                    isActive: $isLoggedIn,
                    label: {
                        EmptyView()
                    }
                )
                TextField("First Name", text: $firstName)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                TextField("Last Name", text: $lastName)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                TextField("Email", text: $email)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                Spacer().frame(height: 20)
                Button(action: {
                    if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty {
                        if isValidEmail(email) {
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                            isLoggedIn = true
                        } else {
                            alertTitle = "Invalid Email"
                            alertMessage = "Please enter a valid email address"
                            showAlert = true
                        }
                    } else {
                        alertTitle = "Missing Information"
                        alertMessage = "Please fill out all fields"
                        showAlert = true
                    }
                }, label: {
                    Text("Register").bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                })
                Spacer()
            }
            .padding(.horizontal, 20)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            })
        }.onAppear {
            if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                self.isLoggedIn = true
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}



struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
