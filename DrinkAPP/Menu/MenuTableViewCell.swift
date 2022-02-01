//
//  MenuTableViewCell.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/3.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuDrinkPhoto: UIImageView!
    @IBOutlet weak var menuDrinkNameLabel: UILabel!
    @IBOutlet weak var menuDrinkDetailLabel: UILabel!
    @IBOutlet weak var menuDrinkPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
