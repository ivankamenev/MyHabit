//
//  State.swift
//  MyHabit
//
//  Created by  Ivan Kamenev on 26.02.2021.
//

public enum State {
    case create
    case edit
    var change: State {
        switch self {
        case .create:
            return .edit
        case .edit:
            return .create
        }
    }
}
