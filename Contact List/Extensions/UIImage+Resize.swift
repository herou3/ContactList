//
//  UIImage+resize.swift
//  Contact List
//
//  Created by Pavel Kurilov on 17.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero,
                                                  size: CGSize(width: size.width * percentage,
                                                               height: size.height * percentage)))
        imageView.contentMode = .scaleToFill
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero,
                                                  size: CGSize(width: width,
                                                               height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleToFill
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
