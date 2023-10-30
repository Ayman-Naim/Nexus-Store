//
//  SignUp.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 27/10/2023.
//

import Foundation

struct SignUpModel:Codable{
    let customer: SignUp
    
    
}

struct SignUp: Codable{
    var id: Int?
    var email: String?
}
