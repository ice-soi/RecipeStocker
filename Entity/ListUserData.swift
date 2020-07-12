//
//  ListUserData.swift
//  RecipeStocker
//
//  Created by ice_soi on 2020/01/13.
//  Copyright © 2020 ice_soi. All rights reserved.
//

import SwiftUI
import Combine
import RealmSwift

final class ListUserData: ObservableObject {
    @Published var recipeData = BindableResults(results: try! Realm().objects(Recipe.self))
    @Published var isSearch = false
}
