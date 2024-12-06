//
//  APIHandler.swift
//  IOS
//
//  Created by Curt Spark on 04/12/2024.
//
import Foundation

struct APIHandler {

    public enum APIHandlerError: Error {
        case OK
        case urlCheckFail
        case urlRequestFail(reason: String)
        case decodeModelError(reason: String)
        case decodeBackendErrorResponseError
    }
    
    public enum HTTPMethod: String {
        case POST = "POST"
        case GET = "GET"
        case UPDATE = "UPDATE"
        case DELETE = "DELETE"
    }

    static private func attemptRequest(url: String, method: HTTPMethod, task: TaskModel? = nil, completedtask: CompletedTaskModel? = nil, category: CategoryModel? = nil) async throws(APIHandlerError) -> Data {
        guard let urlObject = URL(string: url) else {
            throw APIHandlerError.urlCheckFail
        }
        var request = URLRequest(url: urlObject)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if (task != nil) {
            request.httpBody = try? JSONEncoder().encode(task)
        }
        if (completedtask != nil) {
            request.httpBody = try? JSONEncoder().encode(completedtask)
        }
        if (category != nil) {
            request.httpBody = try? JSONEncoder().encode(category)
        }

        var requestOutcome: (Data: Data, URLResponse: URLResponse)
        do {
            requestOutcome = try await URLSession.shared.data(from: urlObject)
        } catch {
            throw APIHandlerError.urlRequestFail(reason: error.localizedDescription)
        }

        return requestOutcome.Data
    }

    static public func newTask(task: TaskModel) async throws(APIHandlerError) -> TaskModel {
        let jsondata = try await attemptRequest(url: "http://localhost:8080/tasks", method: HTTPMethod.POST, task: task)
 
        guard let result: TaskModel = try? JSONDecoder().decode(TaskModel.self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

    static public func getTasks() async throws(APIHandlerError) -> [TaskModel] {
        let jsondata = try await attemptRequest(url: "http://localhost:8080/tasks", method: HTTPMethod.GET)
 
        guard let result: [TaskModel] = try? JSONDecoder().decode([TaskModel].self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

    static public func getCategories() async throws(APIHandlerError) -> [CategoryModel] {
        let jsondata = try await attemptRequest(url: "http://localhost:8080/categories", method: HTTPMethod.GET)
 
        guard let result: [CategoryModel] = try? JSONDecoder().decode([CategoryModel].self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

}
