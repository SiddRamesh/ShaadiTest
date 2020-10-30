//
//  ViewController.swift
//  ShaadiTest
//
//  Created by Ramesh Siddanavar on 30/09/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: ShaadiViewModel!

    var currentPage = 1
    var totalPage = 12
    var isLoadingList : Bool = false
    var api = "https://jsonplaceholder.typicode.com/users"
    
    var shaadi : [Shaadi]? = []
    var isCheckShaadi : [Shaadi]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "CEO"

        getList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.prefetchDataSource = self
        tableView.register(UINib(nibName: "ShaadiListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShaadiListTableViewCell")
        
//        viewModel = ShaadiViewModel(pageName: "Lists", delegate: self)
//        viewModel?.fetchShaadi(api: api)
    }
    
    // MVC
    func getList(){
        
        APIManager.sharedInstance.makeGETRequest(url: api, type: [Shaadi].self) { (error, data) in
            if error == nil {
//                print(data as Any)
                if !data!.isEmpty {
                    print("GOT list")
                    DispatchQueue.main.async {
                        if let list = data {
                            self.shaadi = list
                            self.tableView.reloadData()
                        }
                    }//main
                } else {
                    print("No Data Found!")
                }
            } else {
                print("Error:",error ?? "NIL")
            }
        }//API
    }

}


extension ViewController : UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shaadi?.count ?? 0  //viewModel?.totalCount ??
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShaadiListTableViewCell", for: indexPath) as! ShaadiListTableViewCell
        
//        if isLoadingCell(for: indexPath) {
//            //            //TODO
//        } else {
            //
//            guard let shaadi = viewModel?.shaadi(at: indexPath.row) else { fatalError() }
        if let shaadi = self.shaadi?[indexPath.row] {
            cell.setup(shaadi: shaadi)
            cell.starBtn.tag = indexPath.row
            cell.starBtn.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        }
//        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func editButtonPressed(_ sender: UIButton) {
        
        print(sender.tag)   //this value will be same as indexpath.row
        let chk = (self.isCheckShaadi?.contains(where: {$0.id == self.shaadi?[sender.tag].id}))
        
        if chk ?? false {
            self.isCheckShaadi?.remove(at: sender.tag)
        } else {
            self.isCheckShaadi?.append((self.shaadi?[sender.tag])!)
            
        }
        
    }
    
    //MARK: Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let shaadi = self.shaadi?[indexPath.row] {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailListViewController
            vc.shaadi = shaadi
            vc.isCheckShaadi = self.isCheckShaadi
            vc.modalPresentationStyle = .currentContext
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

//MARK:- MVVM
extension ViewController: ShaadiViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // 1
        guard newIndexPathsToReload != nil else {
            LLSpinner.stop()
            self.tableView.isHidden = false
            self.tableView.reloadData()
            return
        }
    }
    
    
    func onFetchFailed(with reason: String) {
        LLSpinner.stop()
        
//        let title = "Warning"
//        let action = UIAlertAction(title: "OK", style: .default)
//        displayAlert(with: title , message: reason, actions: [action])
    }
    
}

/*
extension ViewController: UITableViewDataSourcePrefetching {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        print("viewing number\(indexPath.row) \(String(describing: viewModel?.totalCount)) ,avabilalbe\(String(describing: viewModel?.currentCount))")
        return indexPath.row >= viewModel!.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel?.fetchShaadi(api: self.api)
            print("prefetch..")
        }
    }
}
*/
