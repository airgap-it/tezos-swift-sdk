//
//  HTTP.swift
//  
//
//  Created by Julia Samol on 12.07.22.
//

import Foundation

protocol HTTP {
    func delete<Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter]
    ) async throws -> Response
    
    func get<Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter]
    ) async throws -> Response
    
    func patch<Request: Encodable, Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter],
        request: Request?
    ) async throws -> Response
    
    func post<Request: Encodable, Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter],
        request: Request?
    ) async throws -> Response
    
    func put<Request: Encodable, Response: Decodable>(
        baseURL: URL,
        endpoint: String,
        headers: [HTTPHeader],
        parameters: [HTTPParameter],
        request: Request?
    ) async throws -> Response
}
