//
//  ListTableViewController.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/9.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    var list = [CreateRecords]()
    var amount: Int = 0
    var totalPrice: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let url = URL(string: "https://api.airtable.com/v0/appXPLodmoXD2uSII/List") {
            ListController.shared.fetchList(getURL: url) {[weak self] (records) in
                switch records {
                case .success(let records):
                    DispatchQueue.main.async {
                        self?.fetchList(records)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchList(_ list: [CreateRecords]) {
        DispatchQueue.main.async {
//            self.list.insert(contentsOf: list, at: list.count - 1)
            self.list.append(contentsOf: list)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListTableViewCell.self)", for: indexPath) as? ListTableViewCell else { return UITableViewCell()}

        let list = list[indexPath.row]
        cell.listDrinkNameLabel.text = list.fields.name
        cell.listIceLabel.text = list.fields.ice
        cell.listSweetLabel.text = list.fields.sweet
        cell.listSizeLabel.text = list.fields.size
        cell.listPrice.text = "\(list.fields.price)"
        
        if let image = list.fields.image?[0].url {
            MenuController.shared.fetchImage(getUrl: image) { (image) in
                DispatchQueue.main.async {
                    cell.listPhoto.image = image
                }
            }
        }
        // Configure the cell...

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
        if let url = URL(string: "https://api.airtable.com/v0/appXPLodmoXD2uSII/List/" + "\(list[indexPath.row].id ?? "")") {
            ChangeListController.shared.deleteList(getURL: url)
        }
        
        list.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        
        
        tableView.reloadData()
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
