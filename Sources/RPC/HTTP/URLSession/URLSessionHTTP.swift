//
//  URLSessionHTTP.swift
//  
//
//  Created by Julia Samol on 03.08.22.
//

import Foundation

public struct URLSessionHTTP: HTTP {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func delete<Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter]
    ) async throws -> Response {
        var urlRequest = try createRequest(for: .delete, at: baseURL.appendingPathComponent(endpoint), parameters: parameters)
        urlRequest.set(headers: headers)
        
        return try await send(request: urlRequest)
    }
    
    public func get<Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter]
    ) async throws -> Response {
        var urlRequest = try createRequest(for: .get, at: baseURL.appendingPathComponent(endpoint), parameters: parameters)
        urlRequest.set(headers: headers)
        
        return try await send(request: urlRequest)
    }
    
    public func patch<Request: Encodable, Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter],
        request: Request?
    ) async throws -> Response {
        var urlRequest = try createRequest(for: .patch, at: baseURL.appendingPathComponent(endpoint), parameters: parameters)
        
        let encoder = JSONEncoder()
        if let request = request {
            urlRequest.httpBody = try encoder.encode(request)
        }
        urlRequest.set(headers: headers + [("Content-Type", "application/json")])
        
        return try await send(request: urlRequest)
    }
    
    public func post<Request: Encodable, Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter],
        request: Request?
    ) async throws -> Response {
        var urlRequest = try createRequest(for: .post, at: baseURL.appendingPathComponent(endpoint), parameters: parameters)
        
        let encoder = JSONEncoder()
        if let request = request {
            urlRequest.httpBody = try encoder.encode(request)
        }
        urlRequest.set(headers: headers + [("Content-Type", "application/json")])
        
        return try await send(request: urlRequest)
    }
    
    public func put<Request: Encodable, Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter],
        request: Request?
    ) async throws -> Response {
        var urlRequest = try createRequest(for: .put, at: baseURL.appendingPathComponent(endpoint), parameters: parameters)
        
        let encoder = JSONEncoder()
        if let request = request {
            urlRequest.httpBody = try encoder.encode(request)
        }
        urlRequest.set(headers: headers + [("Content-Type", "application/json")])
        
        return try await send(request: urlRequest)
    }
        
    // MARK: Call Handlers
    
    private func createRequest(for method: Method, at url: URL, parameters: [HTTPParameter] = []) throws -> URLRequest {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if !parameters.isEmpty {
            urlComponents?.queryItems = parameters.map { (name, value) in URLQueryItem(name: name, value: value) }
        }
        
        guard let url = urlComponents?.url else {
            throw TezosRPCError.invalidURL(url.absoluteString)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.set(header: ("Accept", "application/json"))
        
        return request
    }
    
    private func send<R: Decodable>(request: URLRequest) async throws -> R {
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw TezosRPCError.unknown
        }
        guard (200..<300).contains(response.statusCode) else {
            throw TezosRPCError.http(response.statusCode)
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(R.self, from: data)
    }
    
    public enum Method: String {
        case delete = "DELETE"
        case get = "GET"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
    }
}

// MARK: Utility Extensions

private extension URLRequest {

    mutating func set(header: HTTPHeader) {
        setValue(header.1, forHTTPHeaderField: header.0)
    }

    mutating func set(headers: [HTTPHeader]) {
        headers.forEach { set(header: $0) }
    }
}
