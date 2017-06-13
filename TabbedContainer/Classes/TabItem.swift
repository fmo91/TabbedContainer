//
//  TabItem.swift
//  Pods
//
//  Created by Fernando on 12/6/17.
//
//

import UIKit

public class TabItem: UIView {
    
    // MARK: - Views -
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Attributes -
    public var highlighted: Bool = false {
        didSet {
            if highlighted {
                self.titleLabel.font = highlightedFont
            } else {
                self.titleLabel.font = unhighlightedFont
            }
        }
    }
    
    public var highlightedFont: UIFont = UIFont.boldSystemFont(ofSize: 16.0) {
        didSet {
            if highlighted {
                self.titleLabel.font = highlightedFont
            }
        }
    }
    public var unhighlightedFont: UIFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            if !highlighted {
                self.titleLabel.font = unhighlightedFont
            }
        }
    }
    
    // MARK: - Init -
    public init(title: String) {
        super.init(frame: .zero)
        
        self.commonInit()
        self.titleLabel.text = title
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.configureViewHierarchy()
        self.layout()
        self.titleLabel.font = unhighlightedFont
    }
    
    // MARK: - Configuration -
    private func configureViewHierarchy() {
        self.addSubview(titleLabel)
    }
    
    private func layout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self, attribute: .top      , relatedBy: .equal, toItem: titleLabel, attribute: .top        , multiplier: 1.0, constant: 0.0    ).isActive = true
        NSLayoutConstraint(item: self, attribute: .leading  , relatedBy: .equal, toItem: titleLabel, attribute: .leading    , multiplier: 1.0, constant: -10.0   ).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing , relatedBy: .equal, toItem: titleLabel, attribute: .trailing   , multiplier: 1.0, constant: 10.0   ).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom   , relatedBy: .equal, toItem: titleLabel, attribute: .bottom     , multiplier: 1.0, constant: 0.0    ).isActive = true
    }
    
}

