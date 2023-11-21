import Foundation

struct Results: Decodable {
    
    let data: [FeedDTO]
    
}

struct FeedDTO: Decodable {
    
    let image: String?
    let title: String
    let url: String
    let category: String
    let country: String
    let description: String
    
}

