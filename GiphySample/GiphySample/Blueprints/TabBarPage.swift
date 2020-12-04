//
//  TabBarPage.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 04/12/20.
//

import UIKit

enum TabBarPage: CaseIterable {
    case feed
    case favourites
        
    init?(index: Int) {
        guard (0..<TabBarPage.allCases.count).contains(index) else { return nil }
        self = TabBarPage.allCases[index]
    }
}

// MARK: Functions
extension TabBarPage {
    func titleValue() -> String {
        switch self {
        case .feed:
            return "Feed"
        case .favourites:
            return "Favourites"
        }
    }
    
    func label() -> String {
        return self.titleValue()
    }

    func orderNumber() -> Int {
        return TabBarPage.allCases.firstIndex(of: self)!
    }
    
    func icon() -> UIImage {
        switch self {
        case .feed:
            return UIImage(systemName: "rectangle.stack")! // NO I18N
        case .favourites:
            return UIImage(systemName: "heart")! // NO I18N
        }
    }
    
    func iconSelected() -> UIImage {
        switch self {
        case .feed:
            return UIImage(systemName: "rectangle.stack.fill")! // NO I18N
        case .favourites:
            return UIImage(systemName: "heart.fill")! // NO I18N
        }
    }
}
