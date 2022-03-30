//
//  ServicesCategoriesTableViewController.swift
//  Services Portal
//
//  Created by David Wilson on 3/30/22.
//

import UIKit

class ServicesCategoriesTableViewController: UITableViewController {
    
    let network = NetworkSingleton.sharedSingleton
    let categories = ServiceCategoriesSingleton.sharedSingleton

    let nc = NotificationCenter.default // Note that default is now a property, not a method call
    let networkSuccessNotification:Notification.Name = Notification.Name("SCNetworkSuccessNotification")
    let networkFailureNotification:Notification.Name = Notification.Name("SCNetworkFailureNotification")
    
    let defaultServiceOfferingUrl : String = "airportservices/v2/airports/servicecategories/"
    
    var networkRetry: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        nc.addObserver(forName: networkSuccessNotification, object: nil, queue: nil, using: catchSuccessNotification)
        nc.addObserver(forName: networkFailureNotification, object: nil, queue: nil, using: catchFailureNotification)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        network.httpsGetRawDataInfoPropertyList(uri: defaultServiceOfferingUrl,
                                                     successNotif: networkSuccessNotification,
                                                     failureNotif: networkFailureNotification)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func catchSuccessNotification(notification:Notification) -> Void {
        DispatchQueue.main.async {
            self.categories.parse()
            self.tableView.reloadData()
        }
    }
    
    func catchFailureNotification(notification:Notification) -> Void {
        DispatchQueue.main.async {
            print("Failure=",notification.description)
            self.networkRetry += 1
            if self.networkRetry < 3 {
                self.network.httpsGetRawDataInfoPropertyList(uri: self.defaultServiceOfferingUrl,
                                                             successNotif: self.networkSuccessNotification,
                                                             failureNotif: self.networkFailureNotification)
            }
        }
    }

    // MARK: - Table view data source

    // UITableViewAutomaticDimension calculates height of label contents/text
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.2 onwards
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Service Categories"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        (cell.contentView.viewWithTag(100) as! UILabel).text = categories.array[indexPath.row].name
        (cell.contentView.viewWithTag(110) as! UILabel).text = categories.array[indexPath.row].code
        (cell.contentView.viewWithTag(120) as! UILabel).text = String(categories.array[indexPath.row].id!)
        (cell.contentView.viewWithTag(130) as! UILabel).text = categories.array[indexPath.row].service_type.name
        (cell.contentView.viewWithTag(140) as! UILabel).text = String(categories.array[indexPath.row].service_type.id!)
        (cell.contentView.viewWithTag(150) as! UILabel).text = categories.array[indexPath.row].description
        return cell
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
