//
//  RegisterResponse.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//
import Foundation

class RegisterResponse: Codable {
    var success: Bool
    var message: String
    var data: User
}

class User: Codable {
    var email: String
    var id: Int
}
