//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Наиль on 12/07/23.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            singleImageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var singleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        singleImageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
       dismiss(animated: true)
    }
    
    @IBAction func didTapSharingButton(_ sender: Any) {
        let items = [image]
        let share = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(share, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
}
