//
//  PrivacyViewController.swift
//  catchMummi
//
//  Created by Nikita Stepanov on 28.02.2024.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var webView: WKWebView?
    
    private var topConstraint: NSLayoutConstraint?
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotate(from: fromInterfaceOrientation)
        topConstraint!.isActive = false
        topConstraint = webView!.topAnchor.constraint(equalTo: view.topAnchor,
                                                     constant: (0))
        topConstraint!.isActive = true
        view.updateConstraintsIfNeeded()
    }
    
    private func configView() -> WKWebViewConfiguration {
        var configuration = WKWebViewConfiguration()
        configuration.preferences = WKPreferences()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        configuration.urlSchemeHandler(forURLScheme: "http")
        configuration.websiteDataStore.httpCookieStore.setCookie(HTTPCookie())
        return configuration
    }
    
    private func wVAppearance() {
        view.backgroundColor = .black
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let noFrameScreen = (screenHeight / screenWidth) > 2
        
        webView = WKWebView(frame: view.bounds,
                            configuration: configView())
        webView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView!)
        webView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        if let url = URL(string: "https://www.freeprivacypolicy.com/live/ab3b7ceb-54bf-4b77-b1b4-6e5d246754a4") {
            let request = URLRequest(url: url)
            webView!.load(request)
        }
        topConstraint = webView!.topAnchor.constraint(equalTo: view.topAnchor)
        
        topConstraint!.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wVAppearance()
    }
}
