//
//  AdminLoginVM.swift
//  Nexus-Admin
//
//  Created by ayman on 28/10/2023.
//

import Foundation
import FirebaseFirestore

import Foundation
class AdminLoginVM{
    
    private var db = Firestore.firestore()
    var AdminDetails: adminacoount?
    
    
    
    func Login(completion:@escaping (Result<[adminModel]?, Error>)->Void){
        
        AdminNetManger.SharedApiManger.fetchDataaa(url: .customer, decodingModel: Admin.self) { result in
            switch result{
            case.success(let admin):
                completion(.success(admin.customers))
            case.failure(let error):
                completion(.failure(error))
            }
        }
        
        
    }
    
    func getAllData(completion:@escaping (adminacoount?, Error?)->Void) {
        
        db.collection("Admin").getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let email = document.data()["AdminEmail"] as? String
                    let pass = document.data()["pass"] as? String
                    print(email)
                    print(pass)
                    self.AdminDetails = adminacoount(useremail: email, userpass: pass)
                    // self.Admina?.email = email
                    //self.Admina?.id = pass
                    completion(adminacoount(useremail: email, userpass: pass),nil)
                }
            }
        }
        
    }
    
    
    
    func LoginAuth(userEmail:String ,pass:String,completion:@escaping (Result<Bool?, Error>)->Void){
        BaseUrl.AdminEmail = userEmail
        self.Login { result in
            switch result{
            case .success(let data):
                self.getAllData { Admin, error in
                    guard let adminAccountt = Admin else{return}
                    if adminAccountt.useremail ==  userEmail && adminAccountt.userpass == pass{
                        if let contentData = try? JSONEncoder().encode(data?.first) {
                            UserDefaults.standard.set(contentData, forKey: "Admin")
                            print("Debug: Loged in ")
                            completion(.success(true))
                        }
                        
                    }
                    else{
                        completion(.failure(loginError.Cantsignin))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                
                
                
            }
            
            
        }
    }
    
}
    enum loginError: Error {
      
      case Cantsignin
    }
