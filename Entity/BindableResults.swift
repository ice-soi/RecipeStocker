//
//  Result.swift
//  RecipeStocker
//
//  Created by ice_soi on 2020/01/05.
//  Copyright © 2020 ice_soi. All rights reserved.
//

import SwiftUI
import RealmSwift
import Combine

class BindableResults<Element>: ObservableObject where Element: RealmSwift.RealmCollectionValue {
    @Published var results: Results<Element>
    private var token: NotificationToken!

    init(results: Results<Element>) {
        self.results = results
        lateInit()
    }
    func lateInit() {
        token = results.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    deinit {
        token.invalidate()
    }
}
