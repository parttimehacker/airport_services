//
//  CheckpointTableViewController.swift
//  Services Portal
//
//  Created by David Wilson on 5/3/22.
//

import UIKit

class CheckpointTableViewController: UITableViewController {

    let network = NetworkSingleton.sharedSingleton
    let categories = ServiceCategoriesSingleton.sharedSingleton
    let offerings = ServiceOfferingSingleton.sharedSingleton
    
    @IBOutlet var typeLabel : UILabel?
    @IBOutlet var categoryLabel : UILabel?

    let nc = NotificationCenter.default // Note that default is now a property, not a method call
    let networkSuccessNotification:Notification.Name = Notification.Name("QueueNetworkSuccessNotification")
    let networkFailureNotification:Notification.Name = Notification.Name("QueueNetworkFailureNotification")
    
    let defaultUrl : String = "/airportservices/v2/references/airports/{iata_code}/queues/"
    var queueRequestUrl : String = ""
    
    // State machine used to download categories; search for vq code; and request service offering based on discovered vq code; 0 or 1
    
    var stateMachine = 0
    
    var networkRetry: Int = 0
    
    func constructUri(baseUri:String, pattern:String, newString:String ) -> String {
        let uri = baseUri
        let replaced = uri.replacingOccurrences(of: pattern, with: newString)
        return replaced
    }
    
    func appendCategoryId(uri: String, code: String) -> String {
        let newUri = constructUri(baseUri: uri, pattern: "{service_category_id}", newString: code)
        return newUri
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        overrideUserInterfaceStyle = .dark
        
        nc.addObserver(forName: networkSuccessNotification, object: nil, queue: nil, using: catchSuccessNotification)
        nc.addObserver(forName: networkFailureNotification, object: nil, queue: nil, using: catchFailureNotification)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stateMachine = 0
        network.httpsGetRawDataInfoPropertyList(uri: queueRequestUrl,
                                                     successNotif: networkSuccessNotification,
                                                     failureNotif: networkFailureNotification)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func catchSuccessNotification(notification:Notification) -> Void {
        DispatchQueue.main.async {
            switch self.stateMachine {
            case 1:
                self.offerings.parse()
                self.tableView.reloadData()
                if self.offerings.array.count > 0 {
                    self.typeLabel?.text = self.offerings.array[0].service_type?.code
                    self.categoryLabel!.text = self.offerings.array[0].service_category?.code
                } else {
                    self.typeLabel?.text = ""
                    self.categoryLabel!.text = ""
                }
            default:
                self.categories.parse()
                // find the vq code
                var found = false
                for i in 0..<self.categories.array.count {
                    if self.categories.array[i].code == "VQ" {
                        found = true
                        self.stateMachine = 1
                        let vqId:String = String(self.categories.array[i].id!)
                        let url = self.appendCategoryId(uri: self.defaultVqOfferingUrl, code: vqId)
                        self.network.httpsGetRawDataInfoPropertyList(uri: url,
                                                                     successNotif: self.networkSuccessNotification,
                                                                     failureNotif: self.networkFailureNotification)
                    }
                }
                if !found {
                    print("vq code not found")
                }
            }
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
