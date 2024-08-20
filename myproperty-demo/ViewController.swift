//
//  ViewController.swift
//  myproperty-demo
//
//  Created by Lynn Thit Nyi Nyi on 19/8/2567 BE.
//

import Foundation

import UIKit
import Alamofire

struct Property: Codable {
    let _id: String
    let _createdAt: String
    let _updatedAt: String
    let _rev: String
    let title: String
    let slug: Slug
    let description: String
    let minPrice: Double
    let maxPrice: Double
    let propertyHero: ImageAsset
    let photos: [ImageAsset]
    let facilities: [Facility]

    struct Slug: Codable {
        let current: String
    }

    struct ImageAsset: Codable {
        let asset: AssetReference

        struct AssetReference: Codable {
            let _ref: String
        }
    }

    struct Facility: Codable {
        let facilityType: String
        let facilityName: String
        let description: String
        let photos: [ImageAsset]
    }
}


struct Listing: Codable {
    let _id: String
    let _createdAt: String
    let property: PropertyReference
    let listingName: String
    let description: String
    let price: Double
    let minimumContractInMonth: Int
    let floor: Int
    let size: Double
    let bedroom: Int
    let bathroom: Int
    let furniture: String
    let listingType: String
    let listingHero: ImageAsset
    let listingPhoto: [ImageAsset]
    let floorPlan: ImageAsset?
    let statusActive: String

    struct PropertyReference: Codable {
        let _ref: String
    }

    struct ImageAsset: Codable {
        let asset: AssetReference

        struct AssetReference: Codable {
            let _ref: String
        }
    }
}

struct PropertyResponse: Codable {
    let result: [Property]
}


struct ListingResponse: Codable {
    let result: [Listing]
}

struct ListingIdResponse: Codable {
    let result: [String]
}

class SanityService {
    private let projectId = "gejbm6fo"
    private let dataset = "production"
    private let baseURL = "https://gejbm6fo.api.sanity.io/v1/data/query/production"
    
    func fetchAllProperties(completion: @escaping (Result<[Property], Error>) -> Void) {
            let query = "*[_type==\"property\"]"
            let urlString = "\(baseURL)?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

            AF.request(urlString).validate().responseDecodable(of: PropertyResponse.self) { response in
                switch response.result {
                case .success(let propertyResponse):
//                    print("Fetched properties: \(propertyResponse.result)")
                    completion(.success(propertyResponse.result))
                case .failure(let error):
                    print("Failed to fetch properties: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    
    func fetchAllListings(completion: @escaping (Result<[Listing], Error>) -> Void) {
        let query = "*[_type==\"listing\"]"
        let urlString = "\(baseURL)?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        AF.request(urlString).validate().responseDecodable(of: ListingResponse.self) { response in
            switch response.result {
            case .success(let listingResponse):
//                print("Fetched listings: \(listingResponse.result)")
                completion(.success(listingResponse.result))
            case .failure(let error):
                print("Failed to fetch listings: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchListingById(id: String, completion: @escaping (Result<Listing, Error>) -> Void) {
        let urlString =
            "https://gejbm6fo.api.sanity.io/v2024-08-19/data/query/production?query=*%5B_type+%3D%3D+%22listing%22+%26%26+_id+%3D%3D+$id%5D%5B0%5D&$id=%22\(id)%22"
        
        print("Request URL: \(urlString)")
        
        // Make the network request
        AF.request(urlString).validate().responseDecodable(of: Listing.self) { response in
            switch response.result {
            case .success(let listing):
                print("Fetched listing: \(listing)")
                completion(.success(listing))
            case .failure(let error):
                print("Failed to fetch listing: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func fetchPropertyById(id: String, completion: @escaping (Result<Property, Error>) -> Void) {
        let urlString = "https://gejbm6fo.api.sanity.io/v2024-08-19/data/query/production?query=*%5B_type+%3D%3D+%22property%22+%26%26+_id+%3D%3D+%24id%5D%5B0%5D&%24id=%22\(id)%22"
        
        // Make the network request
        AF.request(urlString).validate().responseDecodable(of: Property.self) { response in
            switch response.result {
            case .success(let property):
                print("Fetched property: \(property)")
                completion(.success(property))
            case .failure(let error):
                print("Failed to fetch listing: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
    }
    
    func fetchListingIdsByPropertyId(propertyId: String, completion: @escaping (Result<[String], Error>) -> Void) {
        
        let urlString = "https://gejbm6fo.api.sanity.io/v2024-08-19/data/query/production?query=*%5B_type+%3D%3D+%22listing%22+%26%26+property._ref+%3D%3D+%24propertyId%5D._id&%24propertyId=%22\(propertyId)%22"
        
//        print("Request URL: \(urlString)")
        
        // Use responseDecodable to directly decode into the ListingIdResponse model
        AF.request(urlString).validate().responseDecodable(of: ListingIdResponse.self) { response in
            switch response.result {
            case .success(let listingIdResponse):
                // Print the IDs for debugging
                print("Fetched listing IDs for property ID \(propertyId): \(listingIdResponse.result)")
                completion(.success(listingIdResponse.result))
            case .failure(let error):
                print("Failed to fetch listing IDs for property ID \(propertyId): \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }



}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let sanityService = SanityService()
        sanityService.fetchAllProperties { result in
            switch result {
            case .success(let properties):
                print("Successfully fetched ALL properties:")
                for property in properties {
//                    print("ID MOTHERFUCKER \(property._id)")
//                    print("Title: \(property.title)")
//                    print("Description: \(property.description)")
//                    print("Slug: \(property.slug.current)")
//                    print("Min Price: \(String(describing: property.minPrice))")
//                    print("Max Price: \(String(describing: property.maxPrice))")
//                    print("Created At: \(property._createdAt)")
//                    print("-----")
                }
            case .failure(let error):
                print("Error fetching properties: \(error.localizedDescription)")
            }
        }
        
        // Fetch and print listings
        sanityService.fetchAllListings { result in
            switch result {
            case .success(let listings):
                print("Successfully fetched ALL listings:")
//                for listing in listings {
//                    print("Listing Name: \(listing.listingName)")
//                    print("Description: \(listing.description)")
//                    print("Price: \(listing.price)")
//                    print("Minimum Contract In Month: \(listing.minimumContractInMonth)")
//                    print("Floor: \(listing.floor)")
//                    print("Size: \(listing.size)")
//                    print("Bedroom: \(listing.bedroom)")
//                    print("Bathroom: \(listing.bathroom)")
//                    print("Furniture: \(listing.furniture)")
//                    print("Listing Type: \(listing.listingType)")
//                    print("Created At: \(listing._createdAt)")
//                    print("Status Active: \(listing.statusActive)")
//                    print("-----")
//                }
            case .failure(let error):
                print("Error fetching listings: \(error.localizedDescription)")
            }
        }
        
        // Fetch and print listings by property ID
        let propertyId = "bc50f850-c8ba-42e5-bfef-880d28c64729"
        sanityService.fetchListingIdsByPropertyId(propertyId: propertyId) { result in
            switch result {
            case .success(let listings):
                print("Successfully fetched listings for property ID \(propertyId):")
                for listing in listings {
                    print("Listing ID: \(listing)")
                }
            case .failure(let error):
                print("Error fetching listings for property ID \(propertyId): \(error.localizedDescription)")
            }
        }
        
        // Specify the listing ID you want to fetch
               // Fetch the listing by ID
               sanityService.fetchListingById(id: "1abda0d6-d970-42fb-a6d4-b9bb2c5f70d3") { result in
                   switch result {
                   case .success(let listing):
                       print("Successfully fetched listing:")
//                       print("ID: \(listing._id)")
//                       print("Listing Name: \(listing.listingName)")
//                       print("Description: \(listing.description)")
//                       print("Price: \(listing.price)")
//                       print("Minimum Contract In Month: \(listing.minimumContractInMonth)")
//                       print("Floor: \(listing.floor)")
//                       print("Size: \(listing.size)")
//                       print("Bedroom: \(listing.bedroom)")
//                       print("Bathroom: \(listing.bathroom)")
//                       print("Furniture: \(listing.furniture)")
//                       print("Listing Type: \(listing.listingType)")
//                       print("Status Active: \(listing.statusActive)")
//                       print("Created At: \(listing._createdAt)")
//                       print("Listing Hero Asset Ref: \(listing.listingHero.asset._ref)")
                       // Add more fields as needed
                   case .failure(let error):
                       print("Error fetching listing: \(error.localizedDescription)")
                   }
               }
        
               sanityService.fetchPropertyById(id:"bc50f850-c8ba-42e5-bfef-880d28c64729") { result in
               switch result {
               case .success(let property):
                   print("Successfully fetched property: \(property)")
                   print("Property name: \(property.title)")
                   // Example: self.propertyLabel.text = property.name
                   
               case .failure(let error):
                   print("Error fetching property: \(error.localizedDescription)")
               }
            }
    }
    


}

