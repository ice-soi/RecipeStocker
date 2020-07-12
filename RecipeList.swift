/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of Recipe.
*/

import SwiftUI
import Combine
import RealmSwift

struct RecipeList: View {
    @EnvironmentObject var listUserData: ListUserData
    @State var search: String = ""
    var body: some View {
        VStack {
            HStack {
                TextField("検索", text: $search,onCommit: searchToggle)
                    .padding(.all, 5.0)
                    .frame(height: 50.0)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .shadow(radius: /*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                NavigationLink(destination: RecipeEdit()){
                    Text("+")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(/*@START_MENU_TOKEN@*/.trailing, 5.0/*@END_MENU_TOKEN@*/)
                }
            }
            .padding(.horizontal, 10.0)
            HStack {
                List {
                    ForEach(listUserData.recipeData.results){ recipe  in
                        if self.displayList(delflg: recipe.delflg,tag:recipe.tag) == true {
                            NavigationLink(destination:RecipeDetail(recipe: recipe)) {
                                RecipeRow(recipe: recipe)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                    }
                }
                .navigationBarTitle(Text("いままでのレシピ"))
            }
        }
        private func searchToggle() {
            listUserData.isSearch.toggle()
        }
        private func displayList(delflg: Bool,tag:String) -> Bool {
            if delflg == true { return false }
            return (self.search == "") ? true : tag.contains(self.search) == true
        }
        private func delete(at offsets: IndexSet) {
            guard let index = Array(offsets).first else { return }
            do {
                let realm = try Realm()
                let temp = listUserData.recipeData.results[index]
                let recipe = realm.object(ofType: Recipe.self, forPrimaryKey: temp.id)
                
                try! realm.write {
                    recipe?.delflg.toggle()
                    searchToggle()
                }
            } catch {
            }
        }
}

struct RecipeList_Previews: PreviewProvider {

    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            RecipeList()
                .environmentObject(ListUserData())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
