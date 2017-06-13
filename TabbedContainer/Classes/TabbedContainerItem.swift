//
//  TabbedContainerItem.swift
//  Pods
//
//  Created by Fernando on 12/6/17.
//
//

import UIKit

final public class TabbedContainerItem {
    
    public let title: String
    public let viewController: () -> UIViewController
    
    public init(title: String, viewController: @escaping @autoclosure () -> UIViewController) {
        self.title = title
        self.viewController = viewController
    }
    
}
