//
//  WordData.swift
//  WordBookApp
//
//  Created by baigeii on 2026/9/24.
//

import Foundation




@Observable
class WordData{
    var words: [Word] = []
    init(){
        
    }
    func addWord(originalWord: String) {
        var translatedWord = Translate(word: originalWord) //TODO:连接到翻译函数
        var word = Word(originalText: originalWord,translatedText: translatedWord)
    }
}
