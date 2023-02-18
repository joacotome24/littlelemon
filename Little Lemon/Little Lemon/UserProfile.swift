//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Joaquin Tome on 18/2/23.
//

import SwiftUI

struct UserProfile: View {
    let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    let lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    let email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack(spacing: 20) {
            Image("profile-image-placeholder")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .cornerRadius(60)
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
            Text("\(firstName) \(lastName)")
                .font(.title)
                .fontWeight(.bold)
            Text(email)
                .font(.headline)
            Button(action: {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
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
