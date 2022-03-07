//
//  MealService.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import Foundation

enum MealDBAPI  {
    static let host: String = "www.themealdb.com"
    enum EndPoints {
        static let categories = "/api/json/v1/1/categories.php"
        static let filterBy = "/api/json/v1/1/filter.php"
        static let mealBy = "/api/json/v1/1/lookup.php"
    }
}

enum MealServiceError: Error {
    case invalidURL
    case emptyMeal
}

protocol MealService_Protocol {
    func categories(completion: @escaping (Result<[MealCategory], Error>) -> Void)
    func mealSummaryByCategory(category: String, completion: @escaping (Result<[MealSummary], Error>) -> Void)
    func mealBy(id: String, completion: @escaping (Result<[Meal], Error>) -> Void)
}

class MealService: MealService_Protocol {
    private let httpClient: HTTPClient
    private let jsonDecoder: JSONDecoder
    
    struct MealResponseBody: Decodable {
        let meals: [Meal]
    }
    
    struct CategoryResponseBody: Decodable {
        let categories: [MealCategory]
    }
    
    struct MealSummaryResponseBody: Decodable {
        let meals: [MealSummary]
    }
    
    init(httpClient: HTTPClient = HTTPClient.shared) {
        self.httpClient = httpClient
        self.jsonDecoder = JSONDecoder()
    }
    
    func categories(completion: @escaping (Result<[MealCategory], Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = MealDBAPI.host
        urlComponents.path = MealDBAPI.EndPoints.categories
        
        guard let url = urlComponents.url else {
            completion(.failure(MealServiceError.invalidURL))
            return
        }
        
        httpClient.get(url: url) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            case .success(let data):
                do {
                    let result = try self.jsonDecoder.decode(CategoryResponseBody.self, from: data)
                    completion(.success(result.categories))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func mealSummaryByCategory(category: String, completion: @escaping (Result<[MealSummary], Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = MealDBAPI.host
        urlComponents.path = MealDBAPI.EndPoints.filterBy
        
        let queryItemQuery = URLQueryItem(name: "c", value: category)
        urlComponents.queryItems = [queryItemQuery]
        
        guard let url = urlComponents.url else {
            completion(.failure(MealServiceError.invalidURL))
            return
        }
        
        httpClient.get(url: url) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            case .success(let data):
                do {
                    let result = try self.jsonDecoder.decode(MealSummaryResponseBody.self, from: data)
                    completion(.success(result.meals))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func mealBy(id: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = MealDBAPI.host
        urlComponents.path = MealDBAPI.EndPoints.mealBy

        let queryItemQuery = URLQueryItem(name: "i", value: id)
        urlComponents.queryItems = [queryItemQuery]
        
        guard let url = urlComponents.url else {
            completion(.failure(MealServiceError.invalidURL))
            return
        }
        
        httpClient.get(url: url) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            case .success(let data):
                do {
                    let result = try self.jsonDecoder.decode(MealResponseBody.self, from: data)
                    completion(.success(result.meals))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
