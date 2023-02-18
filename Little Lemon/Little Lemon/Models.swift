//
//  Models.swift
//  Little Lemon
//
//  Created by Joaquin Tome on 18/2/23.
//

import Foundation


struct MenuList: Decodable {
    let menu: [MenuItem]
}

struct MenuItem: Decodable {
    let title: String
    let image: String
    let price: String
}
