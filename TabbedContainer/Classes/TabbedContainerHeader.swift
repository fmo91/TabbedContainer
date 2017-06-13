//
//  TabbedContainerHeader.swift
//  Pods
//
//  Created by Fernando on 12/6/17.
//
//

import UIKit

public class TabIndicator: UIView {}

protocol TabbedContainerHeaderDelegate: class {
    func tabbedContainerHeaderDidSelectItem(atIndex index: Int)
}

public class TabbedContainerHeader: UIView {
    // MARK: - Views -
    private(set) public var items: [TabItem] = []
    
    private(set) public lazy var tabIndicator: TabIndicator = {
        let indicator = TabIndicator(frame: .zero)
        indicator.backgroundColor = .blue
        indicator.isUserInteractionEnabled = false
        return indicator
    }()
    
    private var tabIndicatorLeadingConstraint: NSLayoutConstraint?
    private var tabIndicatorWidthConstraint: NSLayoutConstraint?
    
    private(set) public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private(set) public lazy var mainContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Attributes -
    public var indicatorColor: UIColor = .blue {
        didSet {
            tabIndicator.backgroundColor = indicatorColor
        }
    }
    
    private(set) public var titles: [String] = []
    public var selectedTitleIndex: Int = 0
    public var maximumSimultaneousItems: Int = 3
    internal weak var delegate: TabbedContainerHeaderDelegate?
    
    // MARK: - Life cycle -
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Init -
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        self.configureViewHierarchy()
        self.layout()
    }
    
    // MARK: - Configuration -
    private func configureViewHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(mainContainer)
        mainContainer.addSubview(tabIndicator)
    }
    
    private func layout() {
        scrollView      .translatesAutoresizingMaskIntoConstraints = false
        mainContainer   .translatesAutoresizingMaskIntoConstraints = false
        tabIndicator    .translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: scrollView , attribute: .top        , relatedBy: .equal, toItem: self          , attribute: .top      , multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView , attribute: .leading    , relatedBy: .equal, toItem: self          , attribute: .leading  , multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView , attribute: .trailing   , relatedBy: .equal, toItem: self          , attribute: .trailing , multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView , attribute: .bottom     , relatedBy: .equal, toItem: self          , attribute: .bottom   , multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: scrollView , attribute: .top        , relatedBy: .equal, toItem: mainContainer , attribute: .top      , multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView , attribute: .leading    , relatedBy: .equal, toItem: mainContainer , attribute: .leading  , multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView , attribute: .trailing   , relatedBy: .equal, toItem: mainContainer , attribute: .trailing , multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scrollView , attribute: .bottom     , relatedBy: .equal, toItem: mainContainer , attribute: .bottom   , multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self       , attribute: .height     , relatedBy: .equal, toItem: mainContainer , attribute: .height   , multiplier: 1.0, constant: 0.0).isActive = true
        
        tabIndicatorLeadingConstraint = NSLayoutConstraint(item: tabIndicator, attribute: .leading, relatedBy: .equal, toItem: mainContainer , attribute: .leading  , multiplier: 1.0, constant: 0.0)
        tabIndicatorLeadingConstraint!.isActive = true
        NSLayoutConstraint(item: tabIndicator, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0).isActive = true
        NSLayoutConstraint(item: tabIndicator, attribute: .bottom, relatedBy: .equal, toItem: mainContainer , attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        tabIndicatorWidthConstraint = NSLayoutConstraint(item: tabIndicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0)
        tabIndicatorWidthConstraint!.isActive = true
    }
    
    private func configureForState() {
        // Removes all previous tab items
        self.removeAllTabItems()
        self.fillWithCurrentTitles()
        self.highlightFirstTitle()
    }
    
    private func fillWithCurrentTitles() {
        guard titles.isEmpty == false else { return }
        
        // For each title, build a Tab Item
        let tabItems: [TabItem] = titles.map(TabItem.init)
        self.items = tabItems
        
        self.mainContainer.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, item) in tabItems.enumerated() {
            self.mainContainer.addSubview(item)
            self.addGestureRecognizer(to: item)
            item.tag = index
            item.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: self.mainContainer, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
            } else {
                let previousItem: TabItem = tabItems[index - 1]
                NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: previousItem, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
            }

            if tabItems.count <= self.maximumSimultaneousItems {
                NSLayoutConstraint(item: item, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self.scrollView, attribute: .width, multiplier: 1 / CGFloat(tabItems.count), constant: 0.0).isActive = true
            } else {
                NSLayoutConstraint(item: item, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self.scrollView, attribute: .width, multiplier: 1 / CGFloat(tabItems.count), constant: -20.0).isActive = true
            }
            NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: self.mainContainer, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: self.mainContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
            
            if index == tabItems.count - 1 {
                NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal, toItem: self.mainContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
            }
        }
    }
    
    private func addGestureRecognizer(to item: TabItem) {
        item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabItemPressed)))
    }
    
    private func highlightFirstTitle() {
        guard titles.isEmpty == false else { return }
        self.highlightTitleIndex(0)
    }
    
    private func removeAllTabItems() {
        for subview in mainContainer.subviews where subview is TabIndicator == false {
            subview.removeFromSuperview()
        }
    }
    
    private func moveIndicator(to index: Int) {
        let item = items[index]
        let width = item.frame.width
        let originX = item.frame.minX
        
        tabIndicatorWidthConstraint?.constant = width
        tabIndicatorLeadingConstraint?.constant = originX
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let `self` = self else { return }
            self.layoutIfNeeded()
        })
    }
    
    private func highlightTitle(at index: Int) {
        for (_index, item) in items.enumerated() {
            if index == _index {
                item.highlighted = true
            } else {
                item.highlighted = false
            }
        }
    }
    
    public func setTitleNames(_ titles: [String]) {
        self.titles = titles
        self.configureForState()
    }
    
    public func highlightTitleIndex(_ index: Int) {
        guard index < items.count else { return }
        
        self.highlightTitle(at: index)
        self.moveIndicator(to: index)
    }
    
    @objc private func tabItemPressed(sender: UITapGestureRecognizer) {
        guard let tabItem = sender.view as? TabItem else { return }
        let index: Int = tabItem.tag
        self.highlightTitleIndex(index)
        delegate?.tabbedContainerHeaderDidSelectItem(atIndex: tabItem.tag)
    }
    
}




















