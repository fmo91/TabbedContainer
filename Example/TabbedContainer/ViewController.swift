//
//  ViewController.swift
//  TabbedContainer
//
//  Created by fmo91 on 06/12/2017.
//  Copyright (c) 2017 fmo91. All rights reserved.
//

import UIKit
import TabbedContainer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .red
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .blue
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .green
        
        let items = [
            TabbedContainerItem(title: "VC1", viewController: vc1),
            TabbedContainerItem(title: "VC2", viewController: vc2),
            TabbedContainerItem(title: "VC3", viewController: vc3)
        ]
        
        let tabbedContainer = TabbedContainer(on: self)
        tabbedContainer.items = items
        
        self.view.addSubview(tabbedContainer)
        tabbedContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: tabbedContainer, attribute: .top, multiplier: 1.0, constant: -20.0).isActive = true
        NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: tabbedContainer, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: tabbedContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: tabbedContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
    }

}

