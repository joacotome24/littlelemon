//
//  DishDetail.swift
//  Little Lemon
//
//  Created by Joaquin Tome on 18/2/23.
//

import SwiftUI

struct DishDetail: View {
    let dish: Dish

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: dish.image ?? "")) { image in
                    image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
            
            } placeholder: {
                Color.gray
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .scaledToFit()
            .padding()
            
            Text(dish.title ?? "")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Text("Price: \(dish.price ?? "")")
                .font(.headline)
                .fontWeight(.semibold)
                .padding()
            
            Spacer()
        }
        .navigationBarTitle(Text(dish.title ?? ""), displayMode: .inline)
    }
}


