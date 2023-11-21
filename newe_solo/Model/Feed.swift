import Foundation

struct Feed: Hashable {
    
    let url: String
    let image: String?
    let country: String
    let category: String
    let title: String
    let description: String
    var isBookmarked: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
    
    static func ==(lhs: Feed, rhs: Feed) -> Bool {
        return lhs.url == rhs.url
    }
    
}
