//
//  SweetTableViewCell.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/2/8.
//

import UIKit

class SweetTableViewCell: UITableViewCell {

    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
