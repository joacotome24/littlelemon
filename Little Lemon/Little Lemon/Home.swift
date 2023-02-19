//
//  Home.swift
//  Little Lemon
//
//  Created by Joaquin Tome on 18/2/23.
//

import SwiftUI
import Foundation
import CoreData

struct Home: View {
    let persistence = PersistenceController.shared
    
    var body: some View {
        TabView {
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            UserProfile()
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 167, height: 40)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 10)
            }
        }
    }
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
