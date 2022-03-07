//
//  Meal.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import Foundation

struct Meal: Decodable {
    let id: String
    let title: String
    let instructions: String?
    let thumbURL: URL?
    let tags: String?
    let recipes: [Recipe]?
}

extension Meal {
    struct Recipe: Decodable {
        let ingredient: String
        let measure: String
    }
}

extension Meal {
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case title = "strMeal"
        case instructions = "strInstructions"
        case thumbURL = "strMealThumb"
        case tags = "strTags"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let mealDict = try container.decode([String: String?].self)
        
        self.id = mealDict[CodingKeys.id.stringValue]!!
        self.title = mealDict[CodingKeys.title.stringValue]!!
        self.instructions = mealDict[CodingKeys.instructions.stringValue]!
        self.tags = mealDict[CodingKeys.tags.stringValue]!
        
        if let urlString = mealDict[CodingKeys.thumbURL.stringValue] {
            self.thumbURL = URL(string: urlString!)
        } else {
            self.thumbURL = nil
        }
        
        var index = 1
        var recipeItems = [Recipe]()
        while
            let ingredient = mealDict["strIngredient\(index)"] as? String,
            let measure = mealDict["strMeasure\(index)"] as? String,
            !measure.isEmpty,
            ingredient != ""
        {
            recipeItems.append(Recipe(ingredient: ingredient, measure: measure))
            index += 1
        }
        self.recipes = recipeItems
    }
}

struct MealSummary: Codable {
    let id: String
    let title: String
    let thumbURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case title = "strMeal"
        case thumbURL = "strMealThumb"
    }
}
