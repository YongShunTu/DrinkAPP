//
//  ChangeListViewController.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/2/3.
//

import UIKit

class ChangeListViewController: UIViewController {
    
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkDetailLabel: UILabel!
    @IBOutlet weak var changeListTableView: UITableView!
    
    var menu: Fields?
    var presentSelect: CreateRecords?
    
    var iceChangeString: String = ""
    var sweetChangeString: String = ""
    var sizeChangeString: String = ""
    
    var iceSelect: [Int:Bool] = [:]
    var sweetSelect: [Int:Bool] = [:]
    var sizeSelect: [Int:Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(menu)")
        print("\(presentSelect)")
        // Do any additional setup after loading the view.
        
        
        drinkNameLabel.text = menu?.name
        drinkDetailLabel.text = menu?.detail
        iceChangeString = presentSelect?.fields.ice ?? ""
        sweetChangeString = presentSelect?.fields.sweet ?? ""
        sizeChangeString = presentSelect?.fields.size ?? ""
        
        ListController.shared.fetchImage(getURL: menu?.image?[0].url) { (image) in
            DispatchQueue.main.async {
                self.drinkImage.image = image
            }
        }
        presentSelection()
        
    }
    
    
    func presentSelection() {
        let iceCount = menu?.ice?.count ?? 0
        let sweetCount = menu?.sweet?.count ?? 0
        let sizeCount = menu?.size?.count ?? 0
        
        for i in (0...iceCount - 1){
            if menu?.ice?[i] == presentSelect?.fields.ice {
                iceSelect[i] = true
            }
        }
        for i in (0...sweetCount - 1){
            if menu?.sweet?[i] == presentSelect?.fields.sweet {
                sweetSelect[i + iceCount] = true
            }
        }
        for i in (0...sizeCount - 1){
            if menu?.size?[i] == presentSelect?.fields.size {
                sizeSelect[i + iceCount + sweetCount] = true
            }
        }
    }
    
    
    @IBAction func selectionResult(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: changeListTableView)
        if let indexPath = changeListTableView.indexPathForRow(at: point) {
            switch indexPath[0] {
            case 0:
                iceChangeString = menu?.ice?[indexPath[1]] ?? ""
            case 1:
                sweetChangeString = menu?.sweet?[indexPath[1]] ?? ""
            case 2:
                sizeChangeString = menu?.size?[indexPath[1]] ?? ""
            default:
                break
            }
        }
    }
    
    
    @IBAction func changeResultToList(_ sender: UIButton) {
        
        //                OptionsController.shared.optionsResult = OptionsResult(content: options?.content ?? "", ice: iceOptionString, sweet: sweetOptionString, size: sizeOptionString, price: options?.price ?? 0, image: options?.image?[0].url)
        let changeTheList = CreateRecords.init(id: nil, fields: .init(name: presentSelect?.fields.name ?? "", ice: iceChangeString, sweet: sweetChangeString, size: sizeChangeString, price: menu?.price ?? 0, cups: presentSelect?.fields.cups ?? 0, image: [.init(url: presentSelect?.fields.image?[0].url)]))
        
        if let url = URL(string: "https://api.airtable.com/v0/appXPLodmoXD2uSII/List/" + "\(self.presentSelect?.id ?? "")") {
            ChangeListController.shared.updataListSelect(getURL: url, listSelect: changeTheList) { (records) in
                switch records {
                case .success(let records):
                    print(records)
                case .failure(let error):
                    print(error)
                }
            }
        }
        alterSuccess()
    }
    
    func alterSuccess() {
        let controller = UIAlertController(title: "更改訂單成功", message: "太好了", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
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

extension ChangeListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OptionsTableViewCell.self)", for: indexPath) as? OptionsTableViewCell else {
                return UITableViewCell()
            }
            let iceString = menu?.ice?[indexPath.row]
            cell.optionsLabel.text = iceString
            
            let tag = indexPath.row
            cell.optionsButton.tag = tag
            cell.optionsButton.addTarget(self, action: #selector(selectOptions(_:)) , for: .touchUpInside)
            cell.optionsButton.setImage(UIImage(systemName: (iceSelect[tag] ?? false ? "record.circle": "circle")), for: .normal)
            
            return cell
        }else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OptionsTableViewCell.self)", for: indexPath) as? OptionsTableViewCell else {
                return UITableViewCell()
            }
            let sweetString = menu?.sweet?[indexPath.row]
            cell.optionsLabel.text = sweetString
            
            if cell.optionsLabel.text == "固定" {
                cell.optionsButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
            }else if cell.optionsLabel.text != "固定"{
                let tag = indexPath.row + (menu?.sweet?.count ?? 0)
                cell.optionsButton.tag = tag
                cell.optionsButton.addTarget(self, action: #selector(selectOptions), for: .touchUpInside)
                cell.optionsButton.setImage(UIImage(systemName: (sweetSelect[tag] ?? false ) ? "record.circle" :"circle"), for: .normal)
            }
            
            return cell
        }else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OptionsTableViewCell.self)", for: indexPath) as? OptionsTableViewCell else {
                return UITableViewCell()
            }
            let sizeString = menu?.size?[indexPath.row]
            cell.optionsLabel.text = sizeString
            
            let tag = indexPath.row + (menu?.ice!.count ?? 0) + (menu?.sweet?.count ?? 0)
            cell.optionsButton.tag = tag
            cell.optionsButton.addTarget(self, action: #selector(selectOptions), for: .touchUpInside)
            cell.optionsButton.setImage(UIImage(systemName: (sizeSelect[tag] ?? false) ? "record.circle": "circle"), for: .normal)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func selectOptions(_ sender: UIButton) {
        let iceCount = menu?.ice?.count ?? 0
        let sweetCount = menu?.sweet?.count ?? 0
        let sizeCount = menu?.size?.count ?? 0
        
        if sender.tag < iceCount {
            iceSelect.removeAll()
            iceSelect[sender.tag] = !false
            changeListTableView.reloadData()
            print(iceSelect)
        }else if sender.tag >= iceCount && sender.tag < (iceCount + sweetCount){
            sweetSelect.removeAll()
            sweetSelect[sender.tag] = !false
            changeListTableView.reloadData()
            print(sweetSelect)
        }else if sender.tag >= (iceCount + sweetCount) && sender.tag < (iceCount + sweetCount + sizeCount){
            sizeSelect.removeAll()
            sizeSelect[sender.tag] = !false
            changeListTableView.reloadData()
            print(sizeSelect)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return menu?.ice?.count ?? 0
        case 1:
            return menu?.sweet?.count ?? 0
        case 2:
            return menu?.size?.count ?? 0
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
