//
//  WebBrowserViewController.swift
//  Services Portal
//
//  Created by David Wilson on 5/21/22.
//

import UIKit

import WebKit

class WebBrowserViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var webPage: String = "https://theairportguy.io/"
    var controllertitle: String = "Services Portal"
    
    var webView: WKWebView!
    @IBOutlet var contentView: UIView?
    @IBOutlet var pageLabel: UILabel?
    @IBOutlet var loadingIndicator: UIActivityIndicatorView?
    
    func canOpenURL(string: String?) -> Bool {
  
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        return true
        //
        //let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        //let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        //return predicate.evaluate(with: string)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        pageLabel?.textAlignment = .left
        pageLabel?.text = "Loading web page"
        loadingIndicator?.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        pageLabel?.textAlignment = .center
        pageLabel?.text = controllertitle
        loadingIndicator?.stopAnimating()
        loadingIndicator?.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        pageLabel?.textAlignment = .left
        pageLabel?.text = "Loading web page"
        loadingIndicator?.startAnimating()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self

        self.webView = webView

        if let webView = self.webView
        {
            view.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 1, constant: 0)
            let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 1, constant: 0)
            let offset = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0)
            view.addConstraints([height, width, offset])
        }
        
        print(webPage)
        let lastChar = webPage.last!
        if lastChar == "/" {
            let _ = webPage.removeLast()
        }
        print(webPage)
        if canOpenURL(string: webPage) {
            let url = URL(string: webPage)
            webView.load(URLRequest(url: url!))
        } else {
            webPage = "https://theairportguy.io/"
            let url = URL(string: webPage)
            webView.load(URLRequest(url: url!))
        }
        
        overrideUserInterfaceStyle = .dark
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
