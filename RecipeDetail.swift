/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a Recipe.
*/

import SwiftUI

struct RecipeDetail: View {
    var recipe: Recipe

    var body: some View {
        VStack {
            VStack {
                Text(recipe.name)
                    .font(.title)
                    .padding(.top, 10.0)
            }
            VStack {
                HStack {
                    Image(uiImage:recipe.image!)
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                }
            }.frame(width: 400,height:400)
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        let url: NSURL = URL(string: self.recipe.url)! as NSURL; UIApplication.shared.open(url as URL) }) {
                            Text(verbatim: recipe.url)
                    }.padding(.leading, 10.0)
                        .font(Font.custom("HelveticaNeue-Light", size: 24.0))
                }
                HStack(alignment: .center) {
                    Text(recipe.tag)
                        .font(Font.custom("HelveticaNeue-Light", size: 20.0))
                        .padding(.leading, 10.0)
                    Spacer()
                }
                HStack(alignment: .center) {
                    Text(recipe.remark)
                        .font(Font.custom("HelveticaNeue-Light", size: 20.0))
                        .padding(.leading, 10.0)
                    Spacer()
                }
            }
        }
        .navigationBarTitle(Text(verbatim: recipe.name), displayMode: .inline)
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: Recipe())
    }
}
