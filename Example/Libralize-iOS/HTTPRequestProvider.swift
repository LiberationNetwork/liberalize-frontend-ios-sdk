//
//  HTTPRequestProvider.swift
//  Libralize-iOS_Example
//
//  Created by Libralize on 12/10/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

public struct ErrorResponse: Codable {
    var status: String?
    var message: String?
    var code: Int?
}

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete

    var value: String {
        return self.rawValue.uppercased()
    }
}

protocol Target {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }

    var header: [String: String] { get }
    var params: [String: Any]? { get }
}

extension Target {
    var urlComponents: URLComponents? {
        guard var url = URL(string: baseURL) else { return nil }
        url.appendPathComponent(path)
        return URLComponents(url: url, resolvingAgainstBaseURL: false)
    }
    
    var header: [String: String] {
        defaultHeader
    }
    
    var defaultHeader: [String: String] {
        [
           "Content-Type": "application/json",
           "Authorization" : "Basic \(AuthManager.shared.key ?? "")"
        ]
    }
}


class HTTPRequestProvider {
        
    func sendRequest<T: Decodable>(target: Target, completion: @escaping ResponseType<T>) {
        let execute = { (error: ErrorResponse?, result: T?) in
            DispatchQueue.main.async {
                completion(error, result)
            }
        }
        guard let urlRequest = buildRequest(from: target) else {
            execute(ErrorResponse(message: "Invalid response data"), nil)
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                execute(nil, nil)
                print("REQUEST WITH TARGET \(target) failed with error \(String(describing: error))")
                return
            }
            if error != nil {
                var errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                errorResponse?.code = (response as? HTTPURLResponse)?.statusCode
                execute(errorResponse, nil)
                print("REQUEST WITH TARGET \(target) failed with error \(String(describing: error))")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                var errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                errorResponse?.code = response.statusCode
                if errorResponse == nil {
                    errorResponse = ErrorResponse(
                        message: HTTPURLResponse.localizedString(forStatusCode: response.statusCode).capitalized,
                        code: response.statusCode)
                }
                print("REQUEST WITH TARGET \(target) failed with error \(String(describing: errorResponse))")
                execute(errorResponse, nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                formatter.calendar = Calendar(identifier: .iso8601)
                decoder.dateDecodingStrategy = .formatted(formatter)
                let model = try decoder.decode(T.self, from: data)
                execute(nil, model)
                print("REQUEST WITH TARGET \(target) success with response \(String(describing: model))")
            } catch {
                print("REQUEST WITH TARGET \(target) mapping data failed \(String(describing: error))")
                execute(ErrorResponse(message: "Invalid response data"), nil)
            }
        }.resume()
    }
    
    func sendRawRequest(target: Target, completion: @escaping ((_ error: ErrorResponse?, _ response: Data?) -> Void)) {
        let execute = { (error: ErrorResponse?, result: Data?) in
            DispatchQueue.main.async {
                completion(error, result)
            }
        }
        guard let urlRequest = buildRequest(from: target) else {
            execute(ErrorResponse(message: "Invalid response data"), nil)
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                execute(nil, nil)
                return
            }
            if error != nil {
                var errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                errorResponse?.code = (response as? HTTPURLResponse)?.statusCode
                execute(errorResponse, nil)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                var errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                errorResponse?.code = response.statusCode
                if errorResponse == nil {
                    errorResponse = ErrorResponse(
                        message: HTTPURLResponse.localizedString(forStatusCode: response.statusCode).capitalized,
                        code: response.statusCode)
                }
                execute(errorResponse, nil)
                return
            }
            execute(nil, data)
        }.resume()
    }
    
    private func buildRequest(from target: Target) -> URLRequest? {
        guard var urlComponent = target.urlComponents else { return nil }
        if target.method == .get {
            urlComponent.queryItems = target.params?.map({ (key, value) in
                URLQueryItem(name: key, value: "\(value)")
            })
        }
        guard let url = urlComponent.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = target.method.value
        target.header.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        if target.method != .get, let params = target.params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        return request
    }
    
}

