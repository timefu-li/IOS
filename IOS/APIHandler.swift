//
//  APIFetcher.swift
//  IOS
//
//  Created by Curt Spark on 04/12/2024.
//
import Foundation

struct APIHandler {

    private enum FetchTaskError: Error {
        case urlCheckFail
        case decodeTasksError(reasonPhrase: String)
        case decodeBackendErrorResponseError
    }

    static public func fetchTasks() async throws -> [Task] {
        guard let url = URL(string: "http://localhost:8080/tasks") else {
            throw FetchTaskError.urlCheckFail
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(from: url)
 
        guard let result: [Task] = try? JSONDecoder().decode([Task].self, from: data) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: data) else {
                throw FetchTaskError.decodeBackendErrorResponseError
            }

            throw FetchTaskError.decodeTasksError(reasonPhrase: resulterror.reasonPhrase)
        }

        return result
    }

}
