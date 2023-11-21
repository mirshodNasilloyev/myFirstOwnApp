import Foundation
import RxSwift
import RxCocoa

protocol FeedsListServiceDelegate: AnyObject {
    
    func didFetchFeeds(_ feeds: [FeedDTO])
    func didFailWithError(_ error: Error)
    
}

enum FeedsListServiceError: Error {
    
    case invalidURL
    case unknown
    
}

final class FeedsListService {
    
    weak var delegate: FeedsListServiceDelegate?
    
    var selectedCountry: Country? {
        didSet {
            requestFeeds()
        }
    }
    
    private var apiKey = "a8c608673a4d2d63073a6d3ce8b368f5"
    private var baseURL = "http://api.mediastack.com/v1/news"
    
    private let userDefaultManager = UserDefaultsManager.shared
    
    private var currentPage = 0
    private var totalFeeds = 0
    
    private var url: URL? {
        
        var urlComponents = URLComponents(string: baseURL)!
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "access_key", value: apiKey))
        queryItems.append(URLQueryItem(name: "countries", value: userDefaultManager.getSelectedCountry()?.code))
        queryItems.append(URLQueryItem(name: "limit", value: "25"))
        queryItems.append(URLQueryItem(name: "offset", value: String(currentPage * 25)))
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
        
    }
    
    func requestFeeds()  {
        guard let url = url else {
            delegate?.didFailWithError(FeedsListServiceError.invalidURL)
            return
        }
            
        let session = URLSession(configuration: .default)
            
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
                
            if let error = error {
                    
                self.delegate?.didFailWithError(error)
                
            } else if let data = data  {
                
                self.parseJSON(data) { result in
                    
                    switch result {
                        
                    case .success(let newFeeds):
                        
                        self.totalFeeds = newFeeds.count
                        self.delegate?.didFetchFeeds(newFeeds)
                        
                    case .failure(let error):
                        
                        self.delegate?.didFailWithError(error)
                        
                    }
                }
                    
            } else {
                    
                self.delegate?.didFailWithError(FeedsListServiceError.unknown)
                    
            }
        }
        
        task.resume()
        
    }
        
    func parseJSON(_ data: Data, completion: @escaping (Result<[FeedDTO], Error>) -> Void) {
        
        do {
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Results.self, from: data)
            completion(.success(decodedData.data))
            
        } catch {
            
            completion(.failure(error))
            
        }
    }
    
    func loadMoreFeeds() {
        guard currentPage * 25 < totalFeeds else {
            return
        }
        
        currentPage += 1
        requestFeeds()
        
    }
}



