//
//  ShaadiListTableViewCell.swift
//  ShaadiTest
//
//  Created by Ramesh Siddanavar on 01/10/20.
//

import UIKit

class ShaadiListTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet var websiteLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet var starBtn: UIButton!

    var isFav = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(shaadi:Shaadi){
        self.nameLbl.text = shaadi.name
        self.phoneLbl.text = shaadi.phone
        self.companyLbl.text = shaadi.company.name
        self.websiteLbl.text = shaadi.website
    }
    
    @IBAction func makeFav(){
        
        self.isFav.toggle()
        self.starBtn.tintColor = self.isFav ? .systemYellow : .darkGray
        
    }
    
    
    
}
