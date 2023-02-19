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
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 73/255, green: 94/255, blue: 87/255))
                    .padding(.top, 20)
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Little Lemon")
                                .font(.largeTitle)
                                .foregroundColor(Color(red: 0.957, green: 0.808, blue: 0.078))
                                .fontWeight(.bold)
                                .padding(.horizontal, 20)
                            
                            Text("Chicago")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.regular)
                                .padding(.horizontal, 20)
                            
                            Spacer().frame(height: 15)
                            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                        }
                            
                        Image("Hero image")
                            .resizable()
                            .cornerRadius(8)
                            .padding(.top, 20)
                            .frame(width: 130, height: 150)
                    }.padding(.trailing, 20)
                    TextField("Search menu", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }.padding(.top, 20)

            }
            VStack(alignment: .leading) {
                Text("ORDER FOR DELIVERY")
                    .bold()
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                ScrollView(.horizontal){
                    HStack{
                        Text("Starters")
                            .frame(width: 88, height: 41)
                            .background(Color(red: 0.929, green: 0.937, blue: 0.933))
                            .cornerRadius(20)
                            .foregroundColor(.black)
                        Text("Mains")
                            .frame(width: 72, height: 41)
                            .background(Color(red: 0.929, green: 0.937, blue: 0.933))
                            .cornerRadius(20)
                            .foregroundColor(.black)
                        Text("Desserts")
                            .frame(width: 93, height: 41)
                            .background(Color(red: 0.929, green: 0.937, blue: 0.933))
                            .cornerRadius(20)
                            .foregroundColor(.black)
                        Text("Sides")
                            .frame(width: 67, height: 41)
                            .background(Color(red: 0.929, green: 0.937, blue: 0.933))
                            .cornerRadius(20)
                            .foregroundColor(.black)
                    }.padding(.horizontal, 20)
                }
            }
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


