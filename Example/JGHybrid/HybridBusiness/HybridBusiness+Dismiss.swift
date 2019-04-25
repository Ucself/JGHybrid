//
//  InitBusiness.swift
//  DoctorHealth
//
//  Created by 李保君 on 2018/12/26.
//  Copyright © 2018 doctorworker. All rights reserved.
//

import Foundation
import JGHybrid

extension HybridBusiness {
    //MARK: -`dismiss协议`-
    
    /// dismiss
    ///
    /// - Parameter command: command
    @objc func dismiss(command: HybridCommand) {
        command.viewController?.dismiss(animated: true, completion: nil)
        self.handleCallback(command)
    }
    
}
