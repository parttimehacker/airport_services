//
//  QueueDetailsTableViewController.swift
//  Services Portal
//
//  Created by David Wilson on 5/21/22.
//

import UIKit

class QueueDetailsTableViewController: UITableViewController {
    
    let network = NetworkSingleton.sharedSingleton
    let queues = QueueSingleton.sharedSingleton
    let utility = UtilitySingleton.sharedSingleton
    
    @IBOutlet var uriLabel : UILabel?
    @IBOutlet var queuesLabel : UILabel?
    
    var iataCode: String?

    let nc = NotificationCenter.default // Note that default is now a property, not a method call
    let networkSuccessNotification:Notification.Name = Notification.Name("QueueDetailsNetworkSuccessNotification")
    let networkFailureNotification:Notification.Name = Notification.Name("QueueDetailsNetworkFailureNotification")
    
    let defaultUri : String = "airportservices/v2/references/airports/{airport_code}/queues/"
    var modifiedUri : String = ""
    
    // State machine used to download categories; search for vq code; and request service offering based on discovered vq code; 0 or 1
    
    var networkRetry: Int = 0
    
    var noCheckpoints : Bool = true

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
        
        overrideUserInterfaceStyle = .light
        
        nc.addObserver(forName: networkSuccessNotification, object: nil, queue: nil, using: catchSuccessNotification)
        nc.addObserver(forName: networkFailureNotification, object: nil, queue: nil, using: catchFailureNotification)
        
        modifiedUri = utility.constructUri(baseUri: defaultUri, pattern: "{airport_code}", newString: iataCode!)
        
        networkRetry = 0
        network.httpsGetRawDataInfoPropertyList(uri: modifiedUri,
                                                     successNotif: networkSuccessNotification,
                                                     failureNotif: networkFailureNotification)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uriLabel?.text = modifiedUri
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func catchSuccessNotification(notification:Notification) -> Void {
        DispatchQueue.main.async {
            self.queues.parse()
            if self.queues.array.count > 0 {
                let niceNumber = self.utility.numbericSpellout(value: self.queues.array.count)
                self.queuesLabel?.text = String(format: "Airport has %@ security queues", niceNumber)
                self.queues.analyzeQueues()
            } else {
                self.queuesLabel?.text = "ERROR: Airport Queues Not Defined"
            }
            self.tableView.reloadData()
        }
    }
    
    func catchFailureNotification(notification:Notification) -> Void {
        DispatchQueue.main.async {
            print("Failure=",notification.description)
            self.networkRetry += 1
            if self.networkRetry < 3 {
                self.network.httpsGetRawDataInfoPropertyList(uri: self.modifiedUri,
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
        var sections = queues.checkpointQueues.count
        if sections == 0 {
            noCheckpoints = true
            sections = 1
        } else {
            noCheckpoints = false
        }
        return sections
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .black // UIColor.init(red: 255, green: 251, blue: 0, alpha: 1)
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if noCheckpoints {
            return "No Checkpoints Idenfied"
        } else {
            return queues.checkpointQueues[section].name
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noCheckpoints {
            return 0
        }
        if queues.checkpointQueues[section].queues!.count == 0 {
            return 0
        }
        return queues.checkpointQueues[section].queues!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QueueCell", for: indexPath)
        let q = queues.checkpointQueues[indexPath.section].queues![indexPath.row]
        (cell.contentView.viewWithTag(100) as! UILabel).text = queues.array[q].display_name
        (cell.contentView.viewWithTag(110) as! UILabel).text = queues.array[q].queue_type?.name
        (cell.contentView.viewWithTag(120) as! UILabel).text = queues.array[q].queue_status?.name
        (cell.contentView.viewWithTag(130) as! UILabel).text = queues.array[q].operating_hours?.operating_hours
        (cell.contentView.viewWithTag(140) as! UILabel).text = queues.array[q].queue_type?.description
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
