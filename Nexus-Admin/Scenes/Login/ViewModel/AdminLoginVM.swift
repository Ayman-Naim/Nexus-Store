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
    var Admina: adminModel?
    
        
            
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
                                                
    func getAllData(completion:@escaping (adminModel?, Error?)->Void) {
//          db.collection("Admin").addSnapshotListener { (querySnapshot, error) in
//              guard let documents = querySnapshot?.documents else {
//                  print("No documents")
//                  return
//              }
//
//             documents.map { (queryDocumentSnapshot) in
//                  let data = queryDocumentSnapshot.data()
//                  var email = data["AdminEmail"] as? String ?? ""
//                  print(email)
//                 var pass = data["pass"] as? String ?? ""
//                 print(pass)
//                  self.Admina?.append(adminModel(id: 123, email:email ))
//                  completion(self.Admina,nil)
//
//                  return adminModel(id: 123, email:email )
//              }
//          }
        
        db.collection("Admin").getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let email = document.data()["AdminEmail"] as? String
                    let pass = document.data()["pass"] as? Int
                    print(email)
                    print(pass)
                    self.Admina = adminModel(id: pass, email: email)
                   // self.Admina?.email = email
                    //self.Admina?.id = pass
                    completion(self.Admina,nil)
                }
            }
        }
       
      }
     
      
    
}
