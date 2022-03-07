//
//  MealCategory.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import Foundation

struct MealCategory: Codable {
    let id: String
    let name: String
    let thumbURL: URL?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbURL = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}
