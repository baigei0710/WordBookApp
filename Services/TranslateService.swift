//
//  TranslateService.swift
//  WordBookApp
//
//  Created by baigeii on 2026/9/24.
//

import Foundation

//MARK: 接口,模型集合,切换模型

//翻译服务接口
protocol TranslationService{
    func translate(word: String) async throws -> String
}

//可供选择的模型
enum TranslationEngine: String, CaseIterable, Identifiable{
    case deepL = "DeepL"
    case openAI = "OpenAI(CahtGPT)"
    
    var id: String{rawValue}
}

//多模型可切换翻译
class getTranslation{
    
}

//错误集
enum TranslationError: LocalizedError{
    case timeout
    case invalidURL
    case noResult
    case decodeError
    case serverError(code: Int)
    
    var errorDescription: String?{
        switch self{
        case .invalidURL: return "无效请求地址"
        case .serverError(let code): return "服务器错误"
        case .noResult: return "未返回翻译结果"
        case .decodeError: return "解码错误"
        case .timeout: return "任务超时,请检查网络连接"
        }
    }
}

//MARK: 全部翻译服务

//DeepL翻译服务
class DeepLTranslationService: TranslationService {
    init(){
        apiKey = nil
    }
    //DeepL请求体结构
    private struct DeepLRequestBody: Encodable{
        let text: [String]
        let targetLang: String
        enum CodingKeys: String, CodingKey{
            case text
            case targetLang = "target_lang"
        }
    }

    //DeepL返回结构
    private struct DeepLResponse: Decodable{
        struct  TranslationItem: Decodable {
            let text: String
            let detectedSourceLanguage: String
            
            enum CodingKeys: String, CodingKey{
                case text
                case detectedSourceLanguage = "detected_source_language"
            }
        }
        let translations: [TranslationItem]
    }
    
    private let apiKey: String? //TODO: 需要写一个判断是否输入API若无法输入则跳转到输入框
    
    private let endpointURL = "https://api-free.deepl.com/v2/translate"
    //开启异步任务通过API翻译
    func translate(word: String) async throws -> String{
        //检查URL格式是否正确
        guard let url = URL(string: endpointURL) else{
            throw TranslationError.invalidURL
        }
        //写请求
        //全是ai帮忙写的,确实得学习一下网络了XD
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("DeepL-Auth-Key \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //encode为json请求准备发送
        let requestBody = DeepLRequestBody(text: [word], targetLang: "ZH") //TODO: 这边可以改成可选的
        request.httpBody = try JSONEncoder().encode(requestBody)
        //await:发起请求
        request.timeoutInterval = 5.0
        let (data,response) = try await URLSession.shared.data(for: request)
        //校验状态码
        if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode != 200{
            throw TranslationError.serverError(code: httpResponse.statusCode)
        }
        //decode
        let decodeResponse = try JSONDecoder().decode(DeepLResponse.self, from: data)
        //提取结果
        guard let translateResult = decodeResponse.translations.first?.text else{
            throw TranslationError.noResult
        }
        return translateResult
    }
    
}
