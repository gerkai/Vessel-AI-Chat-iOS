//
//  Staff.swift
//  Vessel
//
//  Created by Nicolas Medina on 5/26/23.
//

import Foundation

struct Staff: Codable
{
    var id: Int
    let first_name: String?
    let last_name: String?
    let expert_id: Int?
    let staff_id: Int?
    let quizes_completed: Int?
    let tests_completed: Int?
    let sales: Int?
    let image_url: String?
    
    enum CodingKeys: CodingKey
    {
        case id
        case first_name
        case last_name
        case expert_id
        case staff_id
        case quizes_completed
        case tests_completed
        case sales
        case image_url
    }
}

struct LeaderboardResponse: Codable
{
    let totalSignups: Int?
    let totalQuizesCompleted: Int?
    let totalTestsCompleted: Int?
    let totalSales: Int?
    let ranking: [Staff]
    let expertId: Int?
    
    internal init(totalSignups: Int?,
                  totalQuizesCompleted: Int?,
                  totalTestsCompleted: Int?,
                  totalSales: Int?,
                  ranking: [Staff],
                  expertId: Int?)
    {
        self.totalSignups = totalSignups
        self.totalQuizesCompleted = totalQuizesCompleted
        self.totalTestsCompleted = totalTestsCompleted
        self.totalSales = totalSales
        self.ranking = ranking
        self.expertId = expertId
    }
    
    enum CodingKeys: String, CodingKey
    {
        case totalSignups = "total_signups"
        case totalQuizesCompleted = "total_quizes_completed"
        case totalTestsCompleted = "total_tests_completed"
        case totalSales = "total_sales"
        case ranking
        case expertId = "expert_id"
    }
}
