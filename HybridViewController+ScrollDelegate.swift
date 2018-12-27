//
//  HybridViewController+ScrollDelegate.swift
//  JGHybrid
//
//  Created by goingta on 2018/12/27.
//

import UIKit

private let NAVBAR_COLORCHANGE_POINT:CGFloat = -80

extension HybridViewController: UIScrollViewDelegate {
    
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if (offsetY > NAVBAR_COLORCHANGE_POINT) {
            changeNavBarAnimateWithIsClear(isClear: false)
        } else {
            changeNavBarAnimateWithIsClear(isClear: true)
        }
    }
    
    // private
    private func changeNavBarAnimateWithIsClear(isClear:Bool)
    {
        UIView.animate(withDuration: 0.8, animations: { [weak self] in
            if let weakSelf = self
            {
                if (isClear == true) {
                    weakSelf.navBarBackgroundAlpha = 0
                }
                else {
                    weakSelf.navBarBackgroundAlpha = 1.0
                }
            }
        })
    }
}
