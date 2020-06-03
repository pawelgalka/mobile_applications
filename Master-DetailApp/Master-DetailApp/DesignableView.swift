//
//  DesignableView.swift
//  Master-DetailApp
//
//  Created by Paweł Gałka on 03.06.2020.
//  Copyright © 2020 Paweł Gałka. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
