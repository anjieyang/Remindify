//
//  CustomOperators.swift
//  Remindify
//
//  Created by digmouse on 2023-05-04.
//

import Foundation
import SwiftUI

public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: {
            lhs.wrappedValue ?? rhs
        },
        set: {
            lhs.wrappedValue = $0
        }
    )
}
