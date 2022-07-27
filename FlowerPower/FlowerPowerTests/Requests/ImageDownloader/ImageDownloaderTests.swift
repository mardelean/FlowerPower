//
//  ImageDownloaderTests.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import XCTest
@testable import FlowerPower

final class ImageDownloaderTests: XCTestCase {
    
    func testImageIsDownloaded() {
        let mockedImageRequester = ImageRequesterMock()
        let imageDownloader = ImageDownloader(imageRequester: mockedImageRequester)
        let url = URL(string: "https://images.pexels.com/photos/736230/pexels-photo-736230.jpeg")!

        imageDownloader.downloadImage(
            from: url
        ) { result in
            switch result {
            case .success(let image):
                XCTAssert(image.size != .zero, "Image is decoded")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testImageDownloadFailed() {
        let mockedImageRequester = ImageRequesterMock()
        mockedImageRequester.isSuccessful = false
        let imageDownloader = ImageDownloader(imageRequester: mockedImageRequester)
        let url = URL(string: "https://images.pexels.com/photos/736230/pexels-photo-736230.jpeg")!

        imageDownloader.downloadImage(
            from: url
        ) { result in
            switch result {
            case .success(_):
                XCTFail("An error should be received")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
}


