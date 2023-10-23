//
//  Backport.swift
//  iosApp
//
//  Created by user on 16.10.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

public struct Backport<Content: View> {
    let content: Content
}

public extension View {
    var backport: Backport<Self> { .init(content: self) }
}
