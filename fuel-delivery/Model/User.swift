//
//  User.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 01/12/2020.
//

import Foundation
import Firebase

class User {
    
    private(set) var displayName: String!
    private(set) var email: String!
    private(set) var userId: String!
    private(set) var dateCreated: Date!
    private(set) var overallRating: Double!
    private(set) var totalRating: Double!
    
    init(displayName: String, email: String, userId: String, dateCreated: Date, overallRating: Double, totalRating: Double) {
        self.displayName = displayName
        self.email = email
        self.userId = userId
        self.dateCreated = dateCreated
        self.overallRating = overallRating
        self.totalRating = totalRating
    }
    
    class func parseData(snapshot: DocumentSnapshot?) -> User {
        var user = User(displayName: "", email: "", userId: "", dateCreated: Date(), overallRating: 1.0, totalRating: 1.0)
        guard let snap = snapshot else { return user }
        
            let displayName = snap.get(DISPLAY_NAME) as? String ?? ""
            let email = snap.get(EMAIL) as? String ?? ""
            let userId = snap.documentID
            let dateCreated = snap.get(DATE_CREATED) as? Date ?? Date()
            let overallRating = snap.get(OVERALL_RATING) as? Double ?? 1.0
            let totalRating = snap.get(TOTAL_RATING) as? Double ?? 1.0

        user = User(displayName: displayName, email: email, userId: userId, dateCreated: dateCreated, overallRating: overallRating, totalRating: totalRating)
        return user
    }
}
