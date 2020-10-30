//
//  ShaadiTest
//
//  Created by Ramesh Siddanavar on 30/09/20.
//

import Foundation

protocol ShaadiViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}
