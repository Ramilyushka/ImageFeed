//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Наиль on 29/07/23.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    let ShowWebViewSegueIdentifier = "ShowWebView"
    let oAuth2Service = OAuth2Service()
    
    override func viewDidLoad() {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oAuth2Service.fetchAuthToken(code: code){ result in
            switch result {
            case .success(_):
                vc.dismiss(animated: true)
                let imageListController = ImagesListViewController()
                //let contr
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
