//
//  ViewProtocol.swift
//  MovieIOS7
//
//  Created by Trịnh Xuân Minh on 21/02/2022.
//

import Foundation

protocol BaseSetupView: AnyObject {
    func createComponents()
    
    func setupConstraints()
    
    func binding()
}
