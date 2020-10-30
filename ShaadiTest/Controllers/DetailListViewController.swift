//
//  DetailListViewController.swift
//  ShaadiTest
//
//  Created by Ramesh Siddanavar on 01/10/20.
//

import UIKit

class DetailListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favBtn: UIButton!
    
    var shaadi : Shaadi?
    
    var isCheckShaadi : [Shaadi]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = self.shaadi?.name
        
//        self.favBtn.tintColor = self.isFav ? .systemYellow : .darkGray
//        print(self.isCheckShaadi as Any)
        
        let chk = (self.isCheckShaadi?.contains(where: {$0.id == self.shaadi?.id}))
        if chk ?? false {
            self.favBtn.tintColor = .systemYellow
        } else {
            self.favBtn.tintColor = .darkGray

        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.reloadData()
    }

}

extension DetailListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Username"
        case 2:
            return "Address"
        case 3:
            return "Company"
        case 4:
            return "Phone"
        case 5:
            return "Website"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 4
        case 3:
            return 1
        case 4:
            return 1
        case 5:
            return 1
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as UITableViewCell
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = self.shaadi?.name
        case 1:
            cell.textLabel?.text = self.shaadi?.username
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = self.shaadi?.address.suite
            case 1:
                cell.textLabel?.text = self.shaadi?.address.street
            case 2:
                cell.textLabel?.text = self.shaadi?.address.city
            default:
                cell.textLabel?.text = self.shaadi?.address.zipcode
            }
        case 3:
            cell.textLabel?.text = self.shaadi?.company.name
        case 4:
            cell.textLabel?.text = self.shaadi?.phone
        case 5:
            cell.textLabel?.text = self.shaadi?.website
            cell.accessoryType = .disclosureIndicator
        default:
            cell.textLabel?.text = ""
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
