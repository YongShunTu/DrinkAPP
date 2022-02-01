//
//  OptionsTableViewCell.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/4.
//

import UIKit

enum optionItems {
    case ice, sweet, size
}
class OptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    
    
    var optionItem: optionItems?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        optionsButton.isEnabled = true
       
    }

    
    @objc func selectOptions() {
//        if let optionItem = optionItem {
//            switch optionItem {
//            case .ice:
//                NotificationCenter.default.post(name: NSNotification.Name("clearTempCellStyle"), object: nil)
//            case .sweet:
//                NotificationCenter.default.post(name: NSNotification.Name("clearTempCellStyle"), object: nil)
//            case .size:
//                NotificationCenter.default.post(name: NSNotification.Name("clearTempCellStyle"), object: nil)
//            }
//        }
        
        setBtnStyle(isActive: true)
    }
    
    func setBtnStyle(isActive: Bool) {
        optionsButton.setImage(UIImage(systemName: isActive ? "record.circle":"circle"), for: .normal)
//        if isActive {
//
//        } else {
//            optionsButton.setImage(UIImage(systemName: "circle"), for: .normal)
//        }
    }
}
