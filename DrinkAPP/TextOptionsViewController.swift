//
//  TextOptionsViewController.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/15.
//

import UIKit

class TextOptionsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var optionPhoto: UIImageView!
    @IBOutlet weak var iceTableView: UITableView!
    
    @IBOutlet weak var sweetTableView: UITableView!
    
    @IBOutlet weak var sizeTableView: UITableView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkDetail: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var sweetLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var options: Fields?
    
    var nameOptionString: String = ""
    var iceOptionString: String = "" {
        didSet {
            iceLabel.isEnabled = true
            iceLabel.text = iceOptionString
        }
    }
    var sweetOptionString: String = "" {
        didSet {
            sweetLabel.isEnabled = true
            sweetLabel.text = sweetOptionString
        }
    }
    var sizeOptionString: String = "" {
        didSet {
            sizeLabel.isEnabled = true
            sizeLabel.text = sizeOptionString
        }
    }
    
    //    init?(_ coder: NSCoder, options: Fields) {
    //        self.options = options
    //        super.init(coder: coder)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 252/255, green: 216/255, blue: 180/255, alpha: 1)
        drinkName.text = options?.content
        drinkDetail.text = options?.detail
        
        // Do any additional setup after loading the view.
        MenuController.shared.fetchImage(getUrl: options?.image?[0].url) { (image) in
            DispatchQueue.main.async {
                self.optionPhoto.image = image
                self.optionPhoto.backgroundColor = UIColor(red: 252/255, green: 216/255, blue: 180/255, alpha: 1)
                self.optionPhoto.layer.cornerRadius = 30
                self.optionPhoto.layer.borderWidth = 1
                self.optionPhoto.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    @IBAction func iceOptionsButtonClicked(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: iceTableView)
        if let indexPath = iceTableView.indexPathForRow(at: point) {
            print(indexPath)
            iceOptionString = options?.ice?[indexPath[1]] ?? ""
            iceTableView.visibleCells.forEach ({
                ($0 as? OptionsTableViewCell)?.setBtnStyle(isActive: false)
            })
            
        }
        
        print("\(iceOptionString)")
    }
    @IBAction func sweetOptionsButtonClicked(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: sweetTableView)
        if let indexPath = sweetTableView.indexPathForRow(at: point) {
            print(indexPath)
            sweetOptionString = options?.ice?[indexPath[1]] ?? ""
            sweetTableView.visibleCells.forEach ({
                ($0 as? OptionsTableViewCell)?.setBtnStyle(isActive: false)
            })
            
        }
        
        print("\(sweetOptionString)")
    }
    @IBAction func sizeOptionsButtonClicked(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: sizeTableView)
        if let indexPath = sizeTableView.indexPathForRow(at: point) {
            print(indexPath)
            sizeOptionString = options?.ice?[indexPath[1]] ?? ""
            sizeTableView.visibleCells.forEach ({
                ($0 as? OptionsTableViewCell)?.setBtnStyle(isActive: false)
            })
            
        }
        
        print("\(sizeOptionString)")
    }
    
    
    @IBAction func createListButtonClicked(_ sender: UIButton) {
        guard iceOptionString == "" || sweetOptionString == "" || sizeOptionString == "" else {
            
            ListController.shared.optionsResult = OptionsResult(content: options?.content ?? "", ice: iceOptionString, sweet: sweetOptionString, size: sizeOptionString, image: options?.image?[0].url)
            
            if let url = URL(string: "https://api.airtable.com/v0/appXPLodmoXD2uSII/List") {
                ListController.shared.updataList(getURL: url) { (records) in
                    switch records {
                    case .success(let records):
                        print(records)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            //            dismiss(animated: true, completion: nil)
            return
        }
        alterError()
    }
    
    func alterError() {
        let controller = UIAlertController(title: "!!還沒選完喔!!", message: "再選吧", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //}
    
    //extension OptionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch tableView {
        case iceTableView:
            guard let cell = iceTableView.dequeueReusableCell(withIdentifier: "\(OptionsTableViewCell.self)", for: indexPath) as? OptionsTableViewCell else {
                return UITableViewCell()
            }
            let ice = options?.ice?[indexPath.row]
            cell.optionsLabel.text = ice
            return cell
        case sweetTableView:
            guard let cell = iceTableView.dequeueReusableCell(withIdentifier: "\(OptionsTableViewCell.self)", for: indexPath) as? OptionsTableViewCell else {
                return UITableViewCell()
            }
            let sweet = options?.sweet?[indexPath.row]
            cell.optionsLabel.text = sweet
            return cell
        case sizeTableView:
            guard let cell = iceTableView.dequeueReusableCell(withIdentifier: "\(OptionsTableViewCell.self)", for: indexPath) as? OptionsTableViewCell else {
                return UITableViewCell()
            }
            let ice = options?.size?[indexPath.row]
            cell.optionsLabel.text = ice
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch tableView {
        case iceTableView:
            return options?.ice?.count ?? 0
        case sweetTableView:
            return options?.sweet?.count ?? 0
        case sizeTableView:
            return options?.size?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case iceTableView:
            return "冰塊選擇"
        case sweetTableView:
            return "甜度選擇"
        case sizeTableView:
            return "大小杯選擇"
        default:
            return "error"
        }
    }
    
    
    //}
}
