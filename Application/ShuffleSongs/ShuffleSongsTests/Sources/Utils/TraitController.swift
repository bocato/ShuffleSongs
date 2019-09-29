//
//  TraitController.swift
//  ShuffleSongsTests
//
//  Created by Eduardo Sanches Bocato on 29/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation
import UIKit
import XCTest

enum Device: CaseIterable {
    case phone4inch // iPhone SE, 5, 5S, 5C
    case phone4_7inch // iPhone 8, 7, 6S
    case phone5_5inch // iPhone 8 Plus, 7 Plus, 6S Plus
    case phone5_8inch // iPhone X, XS
    case phone6_5inch // iPhone XS Plus, XR (same resolution but 6.1inch)
    case pad
    
    var width: CGFloat {
        return frameAndTraits(for: self, at: .portrait).0.width
    }
}

enum Orientation {
    case portrait
    case landscape
}

func frameAndTraits(
    for device: Device,
    at orientation: Orientation
) -> (CGRect, UITraitCollection) {
    let traits: UITraitCollection
    let frame: CGRect
    switch (device, orientation) {
    case (.phone4inch, .portrait):
        frame = .init(x: 0, y: 0, width: 320, height: 568)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .regular),
            .init(userInterfaceIdiom: .phone)
        ])
    case (.phone4inch, .landscape):
        frame = .init(x: 0, y: 0, width: 568, height: 320)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .compact),
            .init(userInterfaceIdiom: .phone)
        ])
    case (.phone4_7inch, .portrait):
        frame = .init(x: 0, y: 0, width: 375, height: 667)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .regular),
            .init(userInterfaceIdiom: .phone)
        ])
    case (.phone4_7inch, .landscape):
        frame = .init(x: 0, y: 0, width: 667, height: 375)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .compact),
            .init(userInterfaceIdiom: .phone)
        ])
    case (.phone5_5inch, .portrait):
        frame = .init(x: 0, y: 0, width: 414, height: 736)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .regular),
            .init(userInterfaceIdiom: .phone)
        ])
    case (.phone5_5inch, .landscape):
        frame = .init(x: 0, y: 0, width: 736, height: 414)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .regular),
            .init(verticalSizeClass: .compact),
            .init(userInterfaceIdiom: .phone)
        ])
    case (.phone5_8inch, .portrait):
        frame = .init(x: 0, y: 0, width: 375, height: 812)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .regular),
            .init(userInterfaceIdiom: .phone)
        ])
    case (.phone5_8inch, .landscape):
        frame = .init(x: 0, y: 0, width: 812, height: 375)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .compact),
            .init(userInterfaceIdiom: .phone)
        ])
    case (.pad, .portrait):
        frame = .init(x: 0, y: 0, width: 768, height: 1024)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .regular),
            .init(verticalSizeClass: .regular),
            .init(userInterfaceIdiom: .pad)
        ])
    case (.pad, .landscape):
        frame = .init(x: 0, y: 0, width: 1024, height: 768)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .regular),
            .init(verticalSizeClass: .regular),
            .init(userInterfaceIdiom: .pad)
        ])
    case (.phone6_5inch, .portrait):
        frame = .init(x: 0, y: 0, width: 414, height: 896)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .regular),
            .init(verticalSizeClass: .regular),
            .init(userInterfaceIdiom: .pad)
        ])
    case (.phone6_5inch, .landscape):
        frame = .init(x: 0, y: 0, width: 896, height: 414)
        traits = .init(traitsFrom: [
            .init(horizontalSizeClass: .regular),
            .init(verticalSizeClass: .regular),
            .init(userInterfaceIdiom: .pad)
        ])
    }
    
    return (frame, traits)
}

func traitControllers<V: UIViewController>(
    device: Device = .phone4_7inch,
    orientation: Orientation = .portrait,
    child: V = V(),
    additionalTraits: UITraitCollection = .init(),
    handleAppearanceTransition: Bool = true
) -> (parent: UIViewController, child: V) {
    let parent = UIViewController()
    parent.addChild(child)
    parent.view.addSubview(child.view)
    
    child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    let (frame, traits) = frameAndTraits(for: device, at: orientation)
    parent.view.frame = frame
    child.view.frame = parent.view.frame
    
    parent.view.backgroundColor = .white
    child.view.backgroundColor = .white
    
    let allTraits = UITraitCollection(traitsFrom: [traits, additionalTraits])
    parent.setOverrideTraitCollection(allTraits, forChild: child)
    
    if handleAppearanceTransition {
        parent.beginAppearanceTransition(true, animated: false)
        parent.endAppearanceTransition()
    }
    
    return (parent, child)
}

extension XCTestCase {
    var deviceSizes: [(Device, CGSize)] {
        return Device.allCases.map {
            ($0, frameAndTraits(for: $0, at: .portrait).0.size)
        }
    }
}
