//
//  UIView+Image.swift
//  Instagrid
//
//  Created by Ludovic DANGLOT on 03/05/2021.
//

import UIKit

/// transforme la vue en image
extension UIView {
    var image : UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
