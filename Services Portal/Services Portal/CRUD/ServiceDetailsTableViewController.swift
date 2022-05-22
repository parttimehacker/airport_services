//
//  ServiceDetailsTableViewController.swift
//  Services Portal
//
//  Created by David Wilson on 5/20/22.
//

import UIKit

class ServiceDetailsTableViewController: UITableViewController {

    let network = NetworkSingleton.sharedSingleton
    let offerings = ServiceOfferingSingleton.sharedSingleton
    let utility = UtilitySingleton.sharedSingleton
    
    @IBOutlet var uriLabel : UILabel?
    @IBOutlet var airportLabel : UILabel?
    
    var iataCode: String?
    var categoryCode: String?

    let nc = NotificationCenter.default // Note that default is now a property, not a method call
    let networkSuccessNotification:Notification.Name = Notification.Name("DetailsNetworkSuccessNotification")
    let networkFailureNotification:Notification.Name = Notification.Name("DetailsNetworkFailureNotification")
    
    let defaultVqOfferingUrl : String = "airportservices/v2/airports/{airport_code}/services/servicecategories/{service_category_id}/"
    var vqServiceDetailsOfferingUrl : String = ""
    
    // State machine used to download categories; search for vq code; and request service offering based on discovered vq code; 0 or 1
    
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
    
    func replaceIataCode(uri: String, code: String) -> String {
        let newUri = constructUri(baseUri: uri, pattern: "{airport_code}", newString: code)
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
        
        overrideUserInterfaceStyle = .light
        
        nc.addObserver(forName: networkSuccessNotification, object: nil, queue: nil, using: catchSuccessNotification)
        nc.addObserver(forName: networkFailureNotification, object: nil, queue: nil, using: catchFailureNotification)
        
        let uriCategory = appendCategoryId(uri: defaultVqOfferingUrl, code: categoryCode!)
        vqServiceDetailsOfferingUrl = replaceIataCode(uri: uriCategory, code: iataCode!)
        
        offerings.swapClone(restore: false)
        
        networkRetry = 0
        network.httpsGetRawDataInfoPropertyList(uri: vqServiceDetailsOfferingUrl,
                                                     successNotif: networkSuccessNotification,
                                                     failureNotif: networkFailureNotification)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uriLabel?.text = vqServiceDetailsOfferingUrl
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        offerings.swapClone(restore: true)
    }
    
    func catchSuccessNotification(notification:Notification) -> Void {
        DispatchQueue.main.async {
            self.offerings.parse()
            if self.offerings.array.count > 0 {
                self.airportLabel?.text = self.offerings.array[0].airport?.name
            } else {
                self.airportLabel?.text = "ERROR: Airport Service Offering Not Found"
            }
            self.tableView.reloadData()
        }
    }
    
    func catchFailureNotification(notification:Notification) -> Void {
        DispatchQueue.main.async {
            print("Failure=",notification.description)
            self.networkRetry += 1
            if self.networkRetry < 3 {
                self.network.httpsGetRawDataInfoPropertyList(uri: self.vqServiceDetailsOfferingUrl,
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .black // UIColor.init(red: 255, green: 251, blue: 0, alpha: 1)
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 19)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Service Offering Information"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }

    let airportRow = 0
    let typeAndCategoryRow = 1
    let titleRow = 2
    let subtitleRow = 3
    let descriptionRow = 4
    let bookingUrlRow = 5
    let informationurlRow = 6
    let supporturlRow = 7
    let imageUrRow = 8
    let phoneRow = 9
    let emailRow = 10
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        switch indexPath.row {
        case typeAndCategoryRow:
            var str : String = (offerings.array[0].service_type?.code!)! + ", "
            str += (offerings.array[0].service_category?.code!)!
            (cell.contentView.viewWithTag(100) as! UILabel).text = str
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Type and Category"
        case titleRow:
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].title
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Title"
        case subtitleRow:
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].subtitle
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Sub-Title"
        case descriptionRow:
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].description
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Description"
        case bookingUrlRow:
            cell = tableView.dequeueReusableCell(withIdentifier: "UrlCell", for: indexPath)
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].booking_url
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Booking URL"
        case informationurlRow:
            cell = tableView.dequeueReusableCell(withIdentifier: "UrlCell", for: indexPath)
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].information_url
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Information URL"
        case supporturlRow:
            cell = tableView.dequeueReusableCell(withIdentifier: "UrlCell", for: indexPath)
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].support_url
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Support URL"
        case imageUrRow:
            cell = tableView.dequeueReusableCell(withIdentifier: "UrlCell", for: indexPath)
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].image_url
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Brand Image URL"
        case phoneRow:
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].phone
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Support Phone Numberr"
        case emailRow:
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].email
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Support Email Address"
        default:
            (cell.contentView.viewWithTag(100) as! UILabel).text = offerings.array[0].airport?.name
            (cell.contentView.viewWithTag(110) as! UILabel).text = "Airport"
        }
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebDetailSegue" {
            let tvc = segue.destination as! WebBrowserViewController
            let indexPath = tableView.indexPathForSelectedRow
            switch indexPath?.row {
            case bookingUrlRow:
                tvc.webPage = offerings.array[0].booking_url!
                tvc.controllertitle = "Booking URL"
            case informationurlRow:
                tvc.webPage = offerings.array[0].information_url!
                tvc.controllertitle = "Information URL"
            case supporturlRow:
                tvc.webPage = offerings.array[0].support_url!
                tvc.controllertitle = "Support URL"
            default:
                tvc.webPage = offerings.array[0].image_url!
                tvc.controllertitle = "Brand Image URL"
            }
        } else {
            if segue.identifier == "QueuesSegue" {
                let tvc = segue.destination as! QueueDetailsTableViewController
                tvc.iataCode = iataCode
            }
        }
    }

}
