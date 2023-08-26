//
//  XibLoadView.swift
//  ios-architecture-mvp
//
//  Created by AIR on 2023/04/21.
//

import UIKit

public class XibLoadView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    public func loadNib() {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let view = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
