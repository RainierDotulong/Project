//
//  UserModel.swift
//  Project
//
//  Created by Rainier Dotulong on 1/15/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct UserData: Codable{
    let name : String
    let occupation : String
    
    static func create(userData : UserData) -> String {
        let db = Firestore.firestore()
        
        do {
            let documentID = UUID().uuidString
            try db.collection("UserData").document(documentID).setData(from: userData)
            print("Succesfully Created UserData")
            print(documentID)
            return documentID
        } catch {
            print("Error Creating UserData")
            return "Error"
        }
    }
}
