//
//  WebViewViewCotrollerSpy.swift
//  ImageFeedTests
//
//  Created by Наиль on 23/10/23.
//

import Foundation
@testable import ImageFeed

final class WebViewViewCotrollerSpy: WebViewViewControllerProtocol {
    
    var loadRequestCalled: Bool = false
    
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
}
