//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Наиль on 12/07/23.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var fullImageURL: URL?
    
    private var image: UIImage?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var singleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        setImage()
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        singleImageView.kf.setImage(with: fullImageURL) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                UIBlockingProgressHUD.dismiss()
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showError(error.localizedDescription)
            }
        }
    }
    
    private func showError(_ errorText: String) {
        
        let alert = UIAlertController(
            title: "Что-то пошло не так.",
            message: "Попробовать ещё раз?\n\(errorText)",
            preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(
            title: "Не надо",
            style: .default,
            handler: {_ in
                self.dismiss(animated: true, completion: nil)
            })
        alert.addAction(actionCancel)
        
        let actionContinue = UIAlertAction(
            title: "Повторить",
            style: .default,
            handler: {_ in
                self.setImage()
            })
        alert.addAction(actionContinue)
        
        self.present(alert, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
       dismiss(animated: true, completion: nil)
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
