//
//  Menu.swift
//  Little Lemon
//
//  Created by Joaquin Tome on 18/2/23.
//

import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Text("Little Lemon")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Chicago")
                .font(.title)
                .fontWeight(.medium)
            
            Text("Welcome to Little Lemon. Our menu is carefully crafted to satisfy your cravings and our chefs use only the freshest ingredients to prepare each dish. We hope you enjoy your dining experience with us!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            TextField("Search menu", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            NavigationView {
                FetchedObjects(
                    predicate:buildPredicate(),
                    sortDescriptors: buildSortDescriptors()) {
                        (dishes: [Dish]) in
                        List {
                            ForEach(dishes, id:\.self) { dish in
                                NavigationLink(destination: DishDetail(dish: dish)) {
                                    HStack {
                                        Text("\(dish.title ?? "") - \(dish.price ?? "")")
                                        AsyncImage(url: URL(string: dish.image ?? "")!) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 50, height: 50)
                                    }
                                }
                            }
                        }
                    }
            }
        }
        .onAppear(perform: getMenuData)
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }
    
    func getMenuData() {
        
        let persistence = PersistenceController.shared
        let serverUrl = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: serverUrl)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let menuList = try? decoder.decode(MenuList.self, from: data) {
                    
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Dish")
                    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    do {
                        try viewContext.execute(batchDeleteRequest)
                        try viewContext.save()
                    } catch {
                        // handle the error
                    }
                    
                    for menuItem in menuList.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = menuItem.title
                        dish.image = menuItem.image
                        dish.price = menuItem.price
                    }
                    try? viewContext.save()
                }
            }
        }
        task.resume()
    }
}


