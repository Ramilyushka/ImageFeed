//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Наиль on 25/10/23.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    
    func testCallsviewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testCallsFetchPhotosNextPage() {
        //given
        let viewController = ImagesListViewController()
        
        let imagesListServiceStub = ImagesListServicesStub()
        
        let presenter = ImagesListPresenter(
            view: viewController,
            imagesListService: imagesListServiceStub)
        
        viewController.presenter = presenter
        
        //when
        presenter.fetchPhotos()
        
        //then
        XCTAssertTrue(imagesListServiceStub.fetchPhotosNextPageCalled)
    }
    
    func testCallsFetchChangeLike() {
        //given
        let viewController = ImagesListViewController()
        
        let imagesListServiceStub = ImagesListServicesStub()
        
        let presenter = ImagesListPresenter(view:viewController, imagesListService: imagesListServiceStub)
        
        viewController.presenter = presenter
        
        //when
        presenter.fetchChangeLike(photo: Photo.standart) {_ in
        }
        
        //then
        XCTAssertTrue(imagesListServiceStub.fetchChangeLikeCalled)
    }
    
    func testCalculateHeightCell() {
        //given
        let viewController = ImagesListViewController()
        
        let imagesListServiceStub = ImagesListServicesStub()
        
        let presenter = ImagesListPresenter(view:viewController, imagesListService: imagesListServiceStub)
        
        viewController.presenter = presenter
        
        //when
        let height = presenter.calculateHeightRow(size: CGSize(width: 4000.0, height: 6000.0), widthBounds: 393.0)
        //then
        XCTAssertEqual(height, 549.5)
    }
}
