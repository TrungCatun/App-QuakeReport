//
//  WebViewController.swift
//  QuakeReport
//
//  Created by Trung on 11/23/18.
//  Copyright © 2018 Trung. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var urlOfRow = ""
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        if let url = URL(string: urlOfRow) {
            webView.load(URLRequest(url: url))
        }
    }
}






