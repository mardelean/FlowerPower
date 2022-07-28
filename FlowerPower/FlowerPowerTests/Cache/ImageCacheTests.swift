//
//  ImageCacheTests.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import XCTest
@testable import FlowerPower

class ImageCacheTests: XCTestCase {

    let imageCache = ImageCache()

    func testCachingImage() {
        let testImage = RandomImageProvider.makeImage()
        let testKey = "test_key"
        imageCache.setImage(testImage, key: testKey)
        let fetchedImage = imageCache.getImage(forKey: testKey)
        XCTAssertEqual(testImage, fetchedImage)
    }

    func testRemovingImageFromCache()  {
        let testImage = RandomImageProvider.makeImage()
        let testKey = "test_key"
        imageCache.setImage(testImage, key: testKey)
        imageCache.setImage(nil, key: testKey)
        let fetchedImage = imageCache.getImage(forKey: testKey)
        XCTAssertNil(fetchedImage)
    }
    
    func testFetchingImageFromInexistingKey() {
        let fetchedImage = imageCache.getImage(forKey: "inexisting_key")
        XCTAssertNil(fetchedImage)
    }

}
