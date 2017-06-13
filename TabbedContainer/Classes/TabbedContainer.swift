//
//  TabbedContainer.swift
//  Pods
//
//  Created by Fernando on 12/6/17.
//
//

import UIKit

/**
 
 Represents a view that contains view controllers and where you
 
 */
@IBDesignable open class TabbedContainer: UIView {
    
    // MARK: - Views -
    lazy var header: TabbedContainerHeader = {
        var header = TabbedContainerHeader()
        return header
    }()
    
    lazy var container: UIView = {
        let container = UIView()
        return container
    }()
    
    fileprivate var containerController: TabbedMainContainerController?
    public var controller: UIViewController? {
        didSet {
            configureForState()
        }
    }
    
    // MARK: - Attributes -
    @IBInspectable public var tabIndicatorColor: UIColor = UIColor.yellow {
        didSet {
            
        }
    }
    
    public var items: [TabbedContainerItem] = [] {
        didSet {
            configureForState()
        }
    }
    
    // MARK: - Life cycle -
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    public convenience init(on controller: UIViewController) {
        self.init(frame: .zero)
        self.controller = controller
    }
    private func commonInit() {
        self.configureViewHierarchy()
        self.layout()
    }
    
    // MARK: - Configuration -
    private func configureViewHierarchy() {
        header.delegate = self
        self.addSubview(header)
        self.addSubview(container)
    }
    
    private func layout() {
        header      .translatesAutoresizingMaskIntoConstraints = false
        container   .translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self   , attribute: .top       , relatedBy: .equal, toItem: header     , attribute: .top           , multiplier: 1.0, constant: 0.0)   .isActive = true
        NSLayoutConstraint(item: self	, attribute: .leading   , relatedBy: .equal, toItem: header     , attribute: .leading       , multiplier: 1.0, constant: 0.0)   .isActive = true
        NSLayoutConstraint(item: self   , attribute: .trailing  , relatedBy: .equal, toItem: header     , attribute: .trailing      , multiplier: 1.0, constant: 0.0)   .isActive = true
        NSLayoutConstraint(item: self   , attribute: .leading   , relatedBy: .equal, toItem: container	, attribute: .leading       , multiplier: 1.0, constant: 0.0)   .isActive = true
        NSLayoutConstraint(item: self   , attribute: .trailing  , relatedBy: .equal, toItem: container  , attribute: .trailing      , multiplier: 1.0, constant: 0.0)   .isActive = true
        NSLayoutConstraint(item: self   , attribute: .bottom    , relatedBy: .equal, toItem: container	, attribute: .bottom        , multiplier: 1.0, constant: 0.0)   .isActive = true
        NSLayoutConstraint(item: header , attribute: .height    , relatedBy: .equal, toItem: nil        , attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)  .isActive = true
        NSLayoutConstraint(item: header , attribute: .bottom    , relatedBy: .equal, toItem: container  , attribute: .top           , multiplier: 1.0, constant: 0.0)   .isActive = true
    }
    
    private func configureForState() {
        if containerController == nil && controller != nil {
            containerController = TabbedMainContainerController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal)
            containerController!.tabDelegate = self
            
            controller!.addChildViewController(containerController!)
            containerController?.didMove(toParentViewController: controller!)
            
            container.addSubview(containerController!.view)
            containerController!.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: container   , attribute: .top       , relatedBy: .equal, toItem: containerController!.view     , attribute: .top           , multiplier: 1.0, constant: 0.0)   .isActive = true
            NSLayoutConstraint(item: container 	 , attribute: .leading   , relatedBy: .equal, toItem: containerController!.view     , attribute: .leading       , multiplier: 1.0, constant: 0.0)   .isActive = true
            NSLayoutConstraint(item: container   , attribute: .trailing  , relatedBy: .equal, toItem: containerController!.view     , attribute: .trailing      , multiplier: 1.0, constant: 0.0)   .isActive = true
            NSLayoutConstraint(item: container   , attribute: .bottom    , relatedBy: .equal, toItem: containerController!.view     , attribute: .bottom        , multiplier: 1.0, constant: 0.0)   .isActive = true
        }
        
        self.header.setTitleNames(items.map { $0.title })
        self.containerController?.setControllerCreators(items.map { $0.viewController })
    }
    
}

// MARK: - TabbedContainerHeaderDelegate -
extension TabbedContainer: TabbedContainerHeaderDelegate {
    func tabbedContainerHeaderDidSelectItem(atIndex index: Int) {
        self.containerController?.navigateToViewController(at: index)
    }
}

// MARK: - TabbedMainContainerControllerDelegate -
extension TabbedContainer: TabbedMainContainerControllerDelegate {
    func tabbedMainContainerControllerDidScroll(to index: Int) {
        header.highlightTitleIndex(index)
    }
}
