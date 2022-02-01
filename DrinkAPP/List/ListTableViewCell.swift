//
//  ListTableViewCell.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/9.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var listDrinkNameLabel: UILabel!
    @IBOutlet weak var listIceLabel: UILabel!
    @IBOutlet weak var listSweetLabel: UILabel!
    @IBOutlet weak var listSizeLabel: UILabel!
    @IBOutlet weak var listPhoto: UIImageView!
    @IBOutlet weak var listPrice: UILabel!
    @IBOutlet weak var cupsLabel: UILabel!
    @IBOutlet weak var reduceButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        addButton.addTarget(self, action: #selector(addAmount), for: .touchUpInside)

    }
    
//    @objc func addAmount() {
//        
//        ListTableViewCell.cups += 1
////        ListTableViewCell.cups = ListTableViewCell.cups
//        amountLabel.text = "\(ListTableViewCell.cups)"
//        print(addButton.tag)
//    }

}
