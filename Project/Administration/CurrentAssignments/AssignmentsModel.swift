//
//  AssignmentsModel.swift
//  Project
//
//  Created by Rainier Dotulong on 1/9/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AssignmentsModel: Codable {
    
    var assignment : String
    var name : String
    var quality : String
    var tenagaKerja : Int
    var biayaTenagaKerja : Float
    var estimasiTagihan : Float
    var estimasiLabaRugi : Float
    var noRekening : Int
    var namaRekening : String
    var namaBank : String
    var dueDate : Double
    
    var namaBarang : [String]
    var quantity : [Float]
    var pricePerUnit : [Float]
    var pembeli : [String]
    
    static func create(assignment: AssignmentsModel) -> String {
        let db = Firestore.firestore()
        
        do {
            let documentID = UUID().uuidString
            try db.collection("assignment").document(documentID).setData(from: assignment)
            print("Successfully Created assignment Record!")
            print(documentID)
            return documentID
        } catch {
            print("Error Creating Assignment Record!")
            return "error"
        }
        
    }
}
struct Barang: Codable {
    let name : String
    let quantity : Float
    let pricePerUnit : Float
    let pembeli : String
    
    static func create(assignments: Barang) -> String {
        let db = Firestore.firestore()
        
        do {
            let documentID = UUID().uuidString
            try db.collection("Barang").document(documentID).setData(from: assignments)
            print("Succesfully Created Barang")
            print(documentID)
            return documentID
        } catch {
            print("Error Creating Barang")
            return "Error"
        }
    }
}
