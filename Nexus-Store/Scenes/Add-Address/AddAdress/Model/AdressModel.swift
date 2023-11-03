////
////  AdressModel.swift
////  Nexus-Store
////
////  Created by ayman on 29/10/2023.
////
//
//import Foundation
//
//
//struct CustomerAddresses:Codable{
//    let customer_address: Address?
//}
//
///*
//struct Address:Codable{
//    let  id: Int?
//    let  customer_id: Int?
//    let  first_name: String?
//    let  last_name: String?
//    let  address1: String?
//    let  address2: String?
//    let  city: String?
//    let  phone: String?
//    let  name: String?
//}
//*/
//
//struct CustomerAddressesResponse: Codable {
//    let result: [Address]
//    
//    enum CodingKeys: String, CodingKey {
//        case result = "addresses"
//    }
//}
//
// struct Address: Codable{
//     let  id: Int
//     let  customerID: Int
//     let  firstName: String?
//     let  lastName: String?
//     let  address1: String?
//     let  address2: String?
//     let  city: String?
//     let  phone: String?
//     let  name: String?
//     let isDefault: Bool
//     
//     enum CodingKeys: String, CodingKey {
//         case id
//         case customerID = "customer_id"
//         case firstName = "first_name"
//         case lastName = "last_name"
//         case address1
//         case address2
//         case city
//         case phone
//         case name
//         case isDefault = "default"
//     }
// }
// 
//
///*
// 
// {
//   "address1": "1 Rue des Carrieres",
//   "address2": "Suite 1234",
//   "city": "Montreal",
//   "country": "Canada",
//   "country_code": "CA",
//   "country_name": "Canada",
//   "company": "Fancy Co.",
//   "customer_id": {
//     "id": 1073339470
//   },
//   "first_name": "Samuel",
//   "id": 207119551,
//   "last_name": "de Champlain",
//   "name": "Samuel de Champlain",
//   "phone": "819-555-5555",
//   "province": "Quebec",
//   "province_code": "QC",
//   "zip": "G1R 4P5"
// }
// */
//
///*
//{
//    "addresses": [
//        {
//            "id": 8491740659948,
//            "customer_id": 6921162883308,
//            "first_name": "ayman",
//            "last_name": "mohamed",
//            "company": null,
//            "address1": "1 Rue des Carrieres",
//            "address2": "Suite 1234",
//            "city": "Montreal",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "819-555-5555",
//            "name": "ayman mohamed",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": true
//        },
//        {
//            "id": 8491741380844,
//            "customer_id": 6921162883308,
//            "first_name": "ss",
//            "last_name": null,
//            "company": null,
//            "address1": "1 Rue des Carrieres",
//            "address2": "Suite 1234",
//            "city": "Montreal",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "819-555-5555",
//            "name": "ss",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        },
//        {
//            "id": 8491749867756,
//            "customer_id": 6921162883308,
//            "first_name": "ssss",
//            "last_name": null,
//            "company": null,
//            "address1": "1 Rue des Carrieres",
//            "address2": "Suite 1234",
//            "city": "Montreal",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "819-555-5555",
//            "name": "ssss",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        },
//        {
//            "id": 8491750523116,
//            "customer_id": 6921162883308,
//            "first_name": "ayman",
//            "last_name": "mohamed",
//            "company": null,
//            "address1": "1 Rue des Carrieres1",
//            "address2": "Suite 1234",
//            "city": "Montreal",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "819-555-5555",
//            "name": "ayman mohamed",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        },
//        {
//            "id": 8491822579948,
//            "customer_id": 6921162883308,
//            "first_name": "ayman",
//            "last_name": "mohamed",
//            "company": null,
//            "address1": "1 Rue des Carrieres1",
//            "address2": "1 Rue des Carrieres1",
//            "city": "Montreal",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "819-555-5555",
//            "name": "ayman mohamed",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        },
//        {
//            "id": 8491829919980,
//            "customer_id": 6921162883308,
//            "first_name": "Erased",
//            "last_name": null,
//            "company": null,
//            "address1": "Faded",
//            "address2": "Faded",
//            "city": "Add fad",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "asdaS",
//            "name": "Erased",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        },
//        {
//            "id": 8491830542572,
//            "customer_id": 6921162883308,
//            "first_name": "Erased",
//            "last_name": null,
//            "company": null,
//            "address1": "Faded",
//            "address2": "Faded",
//            "city": "Add fad",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "asdaSs",
//            "name": "Erased",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        },
//        {
//            "id": 8491831230700,
//            "customer_id": 6921162883308,
//            "first_name": "Ggdf",
//            "last_name": null,
//            "company": null,
//            "address1": "Sdfgsdfgs",
//            "address2": "Sdfgsdfgs",
//            "city": "Gsdfgsdfg",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "gsdfg",
//            "name": "Ggdf",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        },
//        {
//            "id": 8491836768492,
//            "customer_id": 6921162883308,
//            "first_name": "Amman",
//            "last_name": null,
//            "company": null,
//            "address1": "Alex -3abdel Nader",
//            "address2": "Alex -3abdel Nader",
//            "city": "Alex",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "01228424243",
//            "name": "Amman",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        },
//        {
//            "id": 8491844370668,
//            "customer_id": 6921162883308,
//            "first_name": "ssss",
//            "last_name": null,
//            "company": null,
//            "address1": "1 Rue des Carrieres1",
//            "address2": "1 Rue des Carrieres1",
//            "city": "Montreal",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "819-555-5555",
//            "name": "ssss",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        },
//        {
//            "id": 8491859345644,
//            "customer_id": 6921162883308,
//            "first_name": "Faded",
//            "last_name": null,
//            "company": null,
//            "address1": "Asdfasdf",
//            "address2": "Asdfasdf",
//            "city": "Asdfasdf",
//            "province": null,
//            "country": null,
//            "zip": null,
//            "phone": "asdf",
//            "name": "Faded",
//            "province_code": null,
//            "country_code": null,
//            "country_name": null,
//            "default": false
//        }
//    ]
//}
//*/
