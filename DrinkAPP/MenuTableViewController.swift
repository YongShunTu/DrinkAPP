//
//  MenuTableViewController.swift
//  DrinkAPP
//
//  Created by 塗詠順 on 2022/1/3.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var items = [Records]()
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        if let url = URL(string: "https://api.airtable.com/v0/appXPLodmoXD2uSII/Menu") {
//            MenuController.shared.fetchItems(getURL: url) { (result) in
//                switch result {
//                case .success(let items):
//                    self.upDataItems(items: items)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
    }
    
    // MARK: - Table view data source
    override func viewDidAppear(_ animated: Bool) {
        if animated == true {
            if let url = URL(string: "https://api.airtable.com/v0/appXPLodmoXD2uSII/Menu") {
                MenuController.shared.fetchItems(getURL: url) { (result) in
                    switch result {
                    case .success(let items):
                        self.upDataItems(items: items)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }else{
            
        }
        
    }
    
    
    func upDataItems(items: [Records]) {
        DispatchQueue.main.async {
            self.items = items
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MenuTableViewCell.self)", for: indexPath) as! MenuTableViewCell
        
        let item = items[indexPath.row]
        cell.menuDrinkNameLabel.text = item.fields.content
        cell.menuDrinkDetailLabel.text = item.fields.detail
        cell.menuDrinkPrice.text = "NT$\(item.fields.price)"
        
        if let imageURL = item.fields.image?[0].url {
            MenuController.shared.fetchImage(getUrl: imageURL) { (image) in
                DispatchQueue.main.async {
                    cell.menuDrinkPhoto.image = image
                }
            }
        }

        return cell
    }
    
//    @IBSegueAction func showOptions(_ coder: NSCoder) -> OptionsViewController? {
//        if let row = tableView.indexPathForSelectedRow?.row {
//            return OptionsViewController(coder, options: items[row].fields)
//        }else{
//            return nil
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? OptionsViewController,
           let row = tableView.indexPathForSelectedRow?.row {
            controller.options = items[row].fields
//            present(controller, animated: true, completion: nil)
//            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
