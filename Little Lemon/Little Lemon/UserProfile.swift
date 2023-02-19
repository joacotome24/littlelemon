//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Joaquin Tome on 18/2/23.
//

import SwiftUI
import UIKit


struct UserProfile: View {
    @State private var firstName: String = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    @State private var lastName: String = UserDefaults.standard.string(forKey: kLastName) ?? ""
    @State private var email: String = UserDefaults.standard.string(forKey: kEmail) ?? ""
    @State private var profileImage: UIImage?
    @State private var isEditing: Bool = false

    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack() {
            
            Button(action: {
                    // Implement profile image picker
                }) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .cornerRadius(60)
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    } else {
                        Image("profile-image-placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .cornerRadius(60)
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    }
                }
                Button(action: {
                    // Implement profile image picker
                }) {
                    Text("Change")
            }
            Spacer().frame(height: 15)
            Button(action: {
                isEditing.toggle()
            }) {
                Text(isEditing ? "Cancel" : "Edit")
                    .bold()
                    .frame(width: 150)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.957, green: 0.808, blue: 0.078))
                    .cornerRadius(15)
                    .foregroundColor(.black)
            }
            
            TextField("First Name", text: $firstName)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(isEditing ? Color.gray.opacity(0.1) : Color.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(!isEditing)
            TextField("Last Name", text: $lastName)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(isEditing ? Color.gray.opacity(0.1) : Color.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(!isEditing)
            TextField("Email", text: $email)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(isEditing ? Color.gray.opacity(0.1) : Color.gray.opacity(0.5))
                .cornerRadius(10)
                .disabled(!isEditing)
            
            HStack {
                Button(action: {
                    isEditing = false
                    firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
                    lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
                    email = UserDefaults.standard.string(forKey: kEmail) ?? ""
                }) {
                    Text("Discard Changes")
                        .bold()
                        .frame(width: 150)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        
                }
                Button(action: {
                    UserDefaults.standard.set(firstName, forKey: kFirstName)
                    UserDefaults.standard.set(lastName, forKey: kLastName)
                    UserDefaults.standard.set(email, forKey: kEmail)
                    isEditing = false
                }) {
                    Text("Save Changes")
                        .bold()
                        .frame(width: 150)
                        .padding(.vertical, 12)
                        .background(Color(red: 73/255, green: 94/255, blue: 87/255))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                }
            }
            Spacer().frame(height: 30)
            Button(action: {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }) {
                Text("Logout")
                    .bold()
                    .frame(width: 150)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.957, green: 0.808, blue: 0.078))
                    .cornerRadius(15)
                    .foregroundColor(.black)
            }
        }
        .padding()
    }
}




struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}

