/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A single row to be displayed in a list of Recipe.
*/

import SwiftUI

struct RecipeRow: View {
    var recipe: Recipe

    var body: some View {
        VStack {
            Text(recipe.name)
                .font(.title)
            Spacer()
        }
    }
}

struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeRow(recipe: Recipe())
            RecipeRow(recipe: Recipe())
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}
