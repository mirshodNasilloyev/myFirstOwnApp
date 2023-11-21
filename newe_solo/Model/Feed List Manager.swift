import Foundation
import RxSwift
import RxCocoa

final class FeedListManager {
    
    var completionHandler: ((Result<[Feed], Error>) -> Void)?
    
    private var feeds: [Feed] = []
    
    private let service: FeedsListService
    
    // MARK: Init
    
    init(service: FeedsListService) {
        self.service = service
        self.service.delegate = self
    }
    
    func start() {
        service.requestFeeds()
    }
}

extension FeedListManager: FeedsListServiceDelegate {
    
    func didFetchFeeds(_ feeds: [FeedDTO]) {
        
        let newFeeds = feeds.map { Feed(
            
            url: $0.url,
            image: $0.image,
            country: $0.country,
            category: $0.category,
            title: $0.title,
            description: $0.description,
            isBookmarked: false)
            
        }
        
        self.feeds = newFeeds
        completionHandler?(.success(newFeeds))
        
    }
    
    func didFailWithError(_ error: Error) {
        
        completionHandler?(.failure(error))
        
    }
}
