//
//  Words.swift
//  WordBookApp
//
//  Created by baigeii on 2026/9/24.
//

import Foundation

struct Word :Identifiable,Codable,Hashable{
    let id:UUID
    var originalText: String
    var translatedText: String
    var phonetic: String?
    var changedDate: Date
    var isFavourite: Bool = false
    var category: [String] = ["WordBook"]
    
    init(
        id: UUID = UUID(),
        originalText: String,
        translatedText: String,
        changedDate: Date = Date()
    )
    {
        self.id = id
        self.originalText = originalText
        self.translatedText = translatedText
        self.changedDate = changedDate
    }
}
