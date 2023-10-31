//
//  SignIn.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 31/10/2023.
//

import Foundation

struct SignInModel:Codable{
    let customers: [SignIn]
}

struct SignIn: Codable{
    var id: Int
    var email: String
}
