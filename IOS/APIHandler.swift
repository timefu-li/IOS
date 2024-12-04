//
//  APIFetcher.swift
//  IOS
//
//  Created by Curt Spark on 04/12/2024.
//
import Foundation

struct APIHandler {

    public enum APIHandlerError: Error {
        case OK
        case urlCheckFail
        case urlRequestFail(reasonPhrase: String)
        case decodeTasksError(reasonPhrase: String)
        case decodeBackendErrorResponseError
    }

    static public func fetchTasks() async throws(APIHandlerError) -> [Task] {
        guard let url = URL(string: "http://localhost:8080/tasks") else {
            throw APIHandlerError.urlCheckFail
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var URLRequest: (Data: Data, URLResponse: URLResponse)
        do {
            URLRequest = try await URLSession.shared.data(from: url)
        } catch {
            throw APIHandlerError.urlRequestFail(reasonPhrase: error.localizedDescription)
        }
 
        guard let result: [Task] = try? JSONDecoder().decode([Task].self, from: URLRequest.Data) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: URLRequest.Data) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeTasksError(reasonPhrase: resulterror.reasonPhrase)
        }

        return result
    }

}
