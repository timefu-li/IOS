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
        case PATCH = "PATCH"
        case DELETE = "DELETE"
    }

    static private func attemptRequest(url: String, method: HTTPMethod, task: TaskModel? = nil, completedtask: CompletedTaskModel? = nil, category: CategoryModel? = nil) async throws(APIHandlerError) -> Data {
        guard let urlObject = URL(string: url) else {
            throw APIHandlerError.urlCheckFail
        }
        var request = URLRequest(url: urlObject)
        request.httpMethod = method.rawValue 
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Custom decoder to handle dates properly
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        if (task != nil) {
            request.httpBody = try? encoder.encode(task)
        }
        if (completedtask != nil) {
            request.httpBody = try? encoder.encode(completedtask)
        }
        if (category != nil) {
            request.httpBody = try? encoder.encode(category)
        }

        var requestOutcome: (Data: Data, URLResponse: URLResponse)
        do {
            requestOutcome = try await URLSession.shared.data(for: request)
        } catch {
            throw APIHandlerError.urlRequestFail(reason: error.localizedDescription)
        }

        return requestOutcome.Data
    }

    static public func newTask(task: TaskModel) async throws(APIHandlerError) -> TaskModel {
        let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/tasks", method: HTTPMethod.POST, task: task)
 
        guard let result: TaskModel = try? JSONDecoder().decode(TaskModel.self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

    static public func newCategory(category: CategoryModel) async throws(APIHandlerError) -> CategoryModel {
        let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/categories", method: HTTPMethod.POST, category: category)
 
        guard let result: CategoryModel = try? JSONDecoder().decode(CategoryModel.self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        return result
    }

    static public func newCompletedTask(completedtask: CompletedTaskModel) async throws(APIHandlerError) -> CompletedTaskModel {
        let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/completedtasks", method: HTTPMethod.POST, completedtask: completedtask)

        // Ensure dates can be decoded correctly
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
 
        guard let result: CompletedTaskModel = try? decoder.decode(CompletedTaskModel.self, from: jsondata) else {
            guard let resulterror: BackendError = try? decoder.decode(BackendError.self, from: jsondata) else {
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

    static public func getCompletedTasks() async throws(APIHandlerError) -> [CompletedTaskModel] {
        let jsondata = try await attemptRequest(url: "http://localhost:8080/completedtasks", method: HTTPMethod.GET)

        // Ensure dates can be decoded correctly
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let result: [CompletedTaskModel] = try? decoder.decode([CompletedTaskModel].self, from: jsondata) else {
            guard let resulterror: BackendError = try? JSONDecoder().decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        //print(NSString(data: jsondata, encoding: String.Encoding.utf8.rawValue))
        //do {
        //    let decoder = JSONDecoder()
        //    decoder.dateDecodingStrategy = .iso8601
        //    let result: CompletedTaskModel = try decoder.decode(CompletedTaskModel.self, from: jsondata)
        //    return result
        //} catch {
        //    print("error! \(error)")
        //}

        return result
    }

    static public func newCurrentTask(task: TaskModel) async throws(APIHandlerError) -> CompletedTaskModel {
        let currenttask = try! await APIHandler.getCompletedTasks()[0]
        let updatedcompletedtaskmodel = CompletedTaskModel(completed: Date.now)
        let newcompletedtask = CompletedTaskModel(name: task.name, task: task, started: Date.now)

        // Ensure dates can be decoded correctly
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        // Update current task to be finished
        let jsondata = try await attemptRequest(url: "http://127.0.0.1:8080/completedtasks/\(currenttask.id ?? UUID())?completed=\(Date.now.ISO8601Format())", method: HTTPMethod.PATCH)
        guard let updateresult: CompletedTaskModel = try? decoder.decode(CompletedTaskModel.self, from: jsondata) else {
            guard let resulterror: BackendError = try? decoder.decode(BackendError.self, from: jsondata) else {
                throw APIHandlerError.decodeBackendErrorResponseError
            }

            throw APIHandlerError.decodeModelError(reason: resulterror.reason)
        }

        // Add new current task
        let result: CompletedTaskModel = try! await APIHandler.newCompletedTask(completedtask: newcompletedtask)

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
