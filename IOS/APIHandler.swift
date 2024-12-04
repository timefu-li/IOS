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

    static private func attemptRequest(url: String, method: String) async throws(APIHandlerError) -> Data {
        guard let urlObject = URL(string: url) else {
            throw APIHandlerError.urlCheckFail
        }
        var request = URLRequest(url: urlObject)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var requestOutcome: (Data: Data, URLResponse: URLResponse)
        do {
            requestOutcome = try await URLSession.shared.data(from: urlObject)
        } catch {
            throw APIHandlerError.urlRequestFail(reasonPhrase: error.localizedDescription)
        }

        return requestOutcome.Data
    }

    static public func fetchTasks() async throws(APIHandlerError) -> [Task] {
        let jsondata = try await attemptRequest(url: "http://localhost:8080/tasks", method: "GET")
 
        guard let result: [Task] = try? JSONDecoder().decode([Task].self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeTasksError(reasonPhrase: resulterror.reasonPhrase)
        }

        return result
    }

}
