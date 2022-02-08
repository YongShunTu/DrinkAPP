//
//  OptionsViewController.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/4.
//

import UIKit

class OptionsViewController: UIViewController {
    
    
    
    @IBOutlet weak var optionPhoto: UIImageView!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkDetail: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var sweetLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    var options: Fields?
    var iceSelect: [Int:Bool] = [:]
    var sweetSelect: [Int:Bool] = [:]
    var sizeSelect: [Int:Bool] = [:]
    
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
        //        view.backgroundColor = UIColor(red: 252/255, green: 216/255, blue: 180/255, alpha: 1)
        print("view didload")
        
        drinkName.text = options?.content
        drinkDetail.text = options?.detail
        priceLabel.text = "NT$\(options?.price ?? 0)"
        // Do any additional setup after loading the view.
        MenuController.shared.fetchImage(getUrl: options?.image?[0].url) { (image) in
            DispatchQueue.main.async {
                self.optionPhoto.image = image
                //                self.optionPhoto.backgroundColor = UIColor(red: 252/255, green: 216/255, blue: 180/255, alpha: 1)
                //                self.optionPhoto.layer.cornerRadius = 30
                //                self.optionPhoto.layer.borderWidth = 1
                //                self.optionPhoto.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        if options?.sweet?[0] == "固定" {
            sweetOptionString = options?.sweet?[0] ?? ""
        }
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(clearTempCellStyle), name: NSNotification.Name("clearTempCellStyle"), object: nil)
    }
    @IBAction func optionsButtonClicked(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: optionsTableView)
        if let indexPath = optionsTableView.indexPathForRow(at: point) {
            print(indexPath)
            
            if indexPath[0] == 0 {
                iceOptionString = options?.ice?[indexPath[1]] ?? ""
            }else if indexPath[0] == 1 {
                sweetOptionString = options?.sweet?[indexPath[1]] ?? ""
            }else if indexPath[0] == 2 {
                sizeOptionString = options?.size?[indexPath[1]] ?? ""
            }else{
                
            }
        }
        
        print("\(iceOptionString)\(sweetOptionString)\(sizeOptionString)")
    }
    
    func selectOptionsButtonForSectionForRow(select indexPath: IndexPath ) -> IndexPath {
        return indexPath
    }
    
    @IBAction func createListButtonClicked(_ sender: UIButton) {
        guard iceOptionString == "" || sizeOptionString == "" else {
            
            if sweetOptionString != "" || sweetOptionString == "固定" {
                let optionsResult = CreateRecords.init(id: nil, fields: .init(name: options?.name ?? "", ice: iceOptionString, sweet: sweetOptionString, size: sizeOptionString, price: options?.price ?? 0, cups: 1, image: [.init(url: options?.image?[0].url)]))
                
                if let url = URL(string: "https://api.airtable.com/v0/appXPLodmoXD2uSII/List") {
                    OptionsController.shared.createDrinkList(getURL: url, optionsResult: optionsResult) { (records) in
                        switch records {
                        case .success(let records):
                            print(records)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                navigationController?.popViewController(animated: true)
                return
            }
            alterError()
            return
        }
        alterError()
    }
    
    func alterError() {
        let controller = UIAlertController(title: "還沒選完喔!!", message: "繼續選吧", preferredStyle: .alert)
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
    
}

extension OptionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OptionsTableViewCell.self)", for: indexPath) as? OptionsTableViewCell else {
                return UITableViewCell()
            }
            let iceString = options?.ice?[indexPath.row]
            cell.optionsLabel.text = iceString
            
            let tag = indexPath.row
            cell.optionsButton.tag = tag;
            cell.optionsButton.addTarget(self, action: #selector(selectOptions), for: .touchUpInside)
            cell.optionsButton.setImage(UIImage(systemName: (iceSelect[tag] ?? false ) ? "record.circle" :"circle"), for: .normal)
            
            //            cell.optionsButton.addTarget(self, action: #selector(iceSelectOptions), for: .touchUpInside)
            
            //            print(iceSelect[option ?? ""] ?? false);
            
            //            cell.optionsButton.setImage(UIImage(systemName: (iceSelect[option ?? ""] ?? false) ? "record.circle" :"circle"), for: .normal)
            
            return cell
        }else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OptionsTableViewCell.self)", for: indexPath) as? OptionsTableViewCell else {
                return UITableViewCell()
            }
            let sweetString = options?.sweet?[indexPath.row]
            cell.optionsLabel.text = sweetString

            if cell.optionsLabel.text == "固定" {
                cell.optionsButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
            }else if cell.optionsLabel.text != "固定"{
                let tag = indexPath.row
                cell.optionsButton.tag = tag;
                cell.optionsButton.addTarget(self, action: #selector(selectOptions(_:)), for: .touchUpInside)
                cell.optionsButton.setImage(UIImage(systemName: (sweetSelect[tag] ?? false ) ? "record.circle" :"circle"), for: .normal)
//                print(tag)
            }
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SweetTableViewCell.self)", for: indexPath) as? SweetTableViewCell else {
//                return UITableViewCell()
//            }
//            let sweetString = options?.sweet?[indexPath.row]
//            cell.optionsLabel.text = sweetString
//
//            if cell.optionsLabel.text == "固定" {
//                cell.optionsButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
//            }else if cell.optionsLabel.text != "固定"{
//                let tag = indexPath.row
//                cell.optionsButton.tag = tag;
//                cell.optionsButton.addTarget(self, action: #selector(sweetSelectOptions(_:)), for: .touchUpInside)
//                cell.optionsButton.setImage(UIImage(systemName: (sweetSelect[tag] ?? false ) ? "record.circle" :"circle"), for: .normal)
//                print(tag)
//            }
//
            return cell
        }else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OptionsTableViewCell.self)", for: indexPath) as? OptionsTableViewCell else {
                return UITableViewCell()
            }
            let sizeString = options?.size?[indexPath.row]
            cell.optionsLabel.text = sizeString
            
            let tag = (indexPath.row + (options?.ice!.count ?? 0) + (options?.sweet?.count ?? 0))
            cell.optionsButton.tag = tag
            cell.optionsButton.addTarget(self, action: #selector(selectOptions), for: .touchUpInside)
            cell.optionsButton.setImage(UIImage(systemName: (sizeSelect[tag] ?? false) ? "record.circle": "circle"), for: .normal)
            
            return cell
        }
        return UITableViewCell()
    }
    
    //    @objc func iceSelectOptions(_ sender: UIButton) {
    //        //print( sender.tag);
    //
    //        if let _option = options,
    //           let _ice = _option.ice
    //        {
    //            iceSelect.removeAll();
    //            iceSelect[_ice[sender.tag]] = !(iceSelect[_ice[sender.tag]] ?? false)
    //            optionsTableView.reloadData()
    //        }
    
    
    //        print(iceSelect);
    //        print(sender.tag)
    
    
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
    
    //setBtnStyle(isActive: true)
    //    }
    @objc func selectOptions(_ sender: UIButton) {
        print("\(sender.tag)")
        let iceCount = options?.ice?.count ?? 0
        let sweetCount = options?.sweet?.count ?? 0
        let sizeCount = options?.size?.count ?? 0
        
        if sender.tag < iceCount {
            iceSelect.removeAll()
            iceSelect[sender.tag] = !false
            optionsTableView.reloadData()
            print(iceSelect)
        }else if sender.tag >= iceCount && sender.tag < (iceCount + sweetCount){
            sweetSelect.removeAll()
            sweetSelect[sender.tag] = !false
            optionsTableView.reloadData()
            print(iceSelect)
        }else if sender.tag >= (iceCount + sweetCount) && sender.tag < (iceCount + sweetCount + sizeCount){
            sizeSelect.removeAll()
            sizeSelect[sender.tag] = !false
            optionsTableView.reloadData()
            print(iceSelect)
        }
        
    }
    

    
    func clearTempCellStyle() {
        optionsTableView.visibleCells.forEach({
            ($0 as? OptionsTableViewCell)?.setBtnStyle(isActive: false)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return options?.ice?.count ?? 0
        case 1:
            return options?.sweet?.count ?? 0
        case 2:
            return options?.size?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "冰塊選擇"
        case 1:
            return "甜度選擇"
        case 2:
            return "大小杯選擇"
        default:
            return "error"
        }
    }
    
}
//}
