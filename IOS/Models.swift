//
//  Models.swift
//  IOS
//
//  Created by Curt Spark on 04/12/2024.
//

import SwiftUI
import Foundation

struct BackendColor: Codable, Identifiable, Hashable {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    let id: UUID? = UUID()

    init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public func toSwiftColor() -> Color {
        return Color(red: Double(self.red) / 255.0, green: Double(self.green) / 255.0, blue: Double(self.blue) / 255.0)
    }
}

struct BackendError: Codable, Identifiable {
    let error: Bool
    let reasonPhrase: String
    let id: UUID? = UUID()

    init(error: Bool, reasonPhrase: String) {
        self.error = error
        self.reasonPhrase = reasonPhrase
    }
}

struct Category: Codable, Identifiable, Hashable {
    let name: String?
    let emoji: String?
    let colour: BackendColor?
    let tasks: [Task]?

    let id: UUID

    init(name: String?, emoji: String?, colour: BackendColor?, tasks: [Task]?, id: UUID) {
        self.name = name
        self.emoji = emoji
        self.colour = colour
        self.tasks = tasks

        self.id = id
    }
}

struct Task: Codable, Identifiable, Hashable {
    let name: String?
    let category: Category?
    let completedtasks: [CompletedTask]?

    let id: UUID

    init(name: String?, category: Category?, completedtasks: [CompletedTask]?, id: UUID) {
        self.name = name
        self.category = category
        self.completedtasks = completedtasks

        self.id = id
    }
}

struct CompletedTask: Codable, Identifiable, Hashable {
    let name: String?
    let task: Task?
    let started: Date?
    let completed: Date?

    let id: UUID

    init(name: String?, task: Task?, started: Date?, completed: Date?, id: UUID) {
        self.name = name
        self.task = task
        self.started = started
        self.completed = completed

        self.id = id
    }
}
