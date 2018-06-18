//
//  HybridViewController+UIScrollViewDelegate.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/3/16.
//

import UIKit

//MARK: 模拟大标题 功能 UIScrollViewDelegate
extension HybridViewController {
    //位置变化回调
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let newY = largeTitleViewTop.constant - scrollView.contentOffset.y
        largeTitleViewTop.constant = newY < -largeTitleViewHeight ? -largeTitleViewHeight : (newY > 0 ? 0 : newY)
        _adjustTitleTopConstant(largeTitleViewTop.constant)
        if scrollView.frame.origin.y > 0.0 && scrollView.frame.origin.y < largeTitleViewHeight {
            if scrollView.isDragging {
                scrollView.contentOffset = CGPoint.zero
            }
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        _adjustContentOffset(scrollView)
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            _adjustContentOffset(scrollView)
        }
    }
    //调整回弹
    open func _adjustContentOffset(_ scrollView: UIScrollView) {
        
        let current = largeTitleViewTop.constant
        if current < -largeTitleViewHeight / 2 && current > -largeTitleViewHeight {
            largeTitleViewTop.constant = -largeTitleViewHeight
            _adjustTitleTopConstant(largeTitleViewTop.constant)
        } else if current >= -largeTitleViewHeight / 2 && current < 0 {
            largeTitleViewTop.constant = 0
            _adjustTitleTopConstant(largeTitleViewTop.constant)
        }
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    //根据顶部常量设置Title
    open func _adjustTitleTopConstant(_ topConstant:CGFloat){
        let current = topConstant
        if current < -largeTitleViewHeight / 2 && current > -largeTitleViewHeight {
            //大标题显示大部分的时候
            self.navigationItem.title = self.titleName
        } else if current >= -largeTitleViewHeight / 2 && current < 0 {
            //大标题隐藏大部分的时候
            self.navigationItem.title = ""
        }
    }
}
