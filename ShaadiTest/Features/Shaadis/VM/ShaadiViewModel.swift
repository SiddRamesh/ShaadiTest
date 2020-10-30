//
//  ShaadiTest
//
//  Created by Ramesh Siddanavar on 30/09/20.
//


import Foundation

final class ShaadiViewModel {
    private weak var delegate: ShaadiViewModelDelegate?
    
    private var shaadis: [Shaadi] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    var client : RSDataProvider!
    var pageName : String!
    init( pageName: String, client : RSDataProvider = RSClientHTTPNetworking(), delegate: ShaadiViewModelDelegate) {
        self.pageName = pageName
        self.client = client
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return shaadis.count
    }
    
    func shaadi(at index: Int) -> Shaadi {
        return shaadis[index]
    }
    
    func fetchShaadi(api:String) {
        // 1
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        // 2
//        let url = URL(string:"https://jsonplaceholder.typicode.com/users")!
//        let url = URL(string:K.APIEndpoints.getNowPlaying(pageNaem: pageName, page: currentPage, key: tokenClosure()).path )!
//        print(url)
        client.fetchRemote(Shaadi.self, api: api) { result in
            switch result {
            // 3
            case .failure(let error):
                DispatchQueue.main.async { [unowned self] in
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                    print("Failed")
                }
            // 4
            case .success(let response):
                DispatchQueue.main.async { [unowned self] in
                    // 1
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    // 2
                    
                    print("Got response")
                    print(response)
                    if let response = response as? ShaadiList {
                        self.total = response.totalResults ?? 0
                        if let results =  response.results {
                            self.shaadis.append(contentsOf: results)
                        }
                        if response.page ?? 0 > 1 {
                            if let results =  response.results {
                                let indexPathsToReload = self.calculateIndexPathsToReload(from: results)
                                self.delegate?.onFetchCompleted(with: indexPathsToReload)
                            }
                        } else {
                            self.delegate?.onFetchCompleted(with: .none)
                        }
                    }
                    
                }
            // 5
            case .Validation(_):
                print("Vaidate..")
            }
        }
        
    }
    
    private func calculateIndexPathsToReload(from newModerators: [Shaadi]) -> [IndexPath] {
        let startIndex = shaadis.count - newModerators.count
        let endIndex = startIndex + newModerators.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}




