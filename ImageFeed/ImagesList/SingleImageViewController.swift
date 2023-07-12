//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Наиль on 12/07/23.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage!
    
    @IBOutlet var singleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleImageView.image = image
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
}
