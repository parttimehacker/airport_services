//
//  ServicesPortalUITableViewController.swift
//  Services Portal
//
//  Created by David Wilson on 3/30/22.
//

import UIKit

class ServicesPortalUITableViewController: UITableViewController {
    
    let sections = 4
    let categoryData = [
        ["BoldCell", "airportservices/v2/airports/servicecategories/"],
        ["RegularCell", "Request a list of all service categories. Display types and codes per category."],
        ["BoldCell", "airportservices/v2/airports/services/servicecategories/{service_category_id}/"],
        ["RegularCell", "Request a list of airports that provide virtual queueing to passengers. The category Id obtained from API#1 JSON."],
        ["BoldCell", "airportservices/v2/airports/{airport_code}/services/servicecategories/{service_category_id}/"],
        ["RegularCell", "Request details on an airport's virtual queueing service offering. The IATA codes are obtained from API#2 and category Id obtained from API#1."],
        ["BoldCell", "airportservices/v2/references/airports/{iata_code}/queues/"],
        ["RegularCell", "Request a list of checkpoints and type of queues by airport IATA code."]
    ]

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
        
        overrideUserInterfaceStyle = .light
    }

    // MARK: - Table view data source
    
    // UITableViewAutomaticDimension calculates height of label contents/text
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.2 onwards
        return UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        headerView.textLabel!.textColor = UIColor.black
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
  
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = section + 1
        let headerName = "Airport Services Portal API#" + String(header)
        // print(headerName)
        return headerName
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = categoryData[(indexPath.section*2)+indexPath.row][0]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)
        let itemString = categoryData[(indexPath.section*2) + indexPath.row][1]
        print(cellString)
        print(indexPath)
        (cell.contentView.viewWithTag(100) as! UILabel).text = itemString
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
