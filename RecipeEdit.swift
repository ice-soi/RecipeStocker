//
//  RecipeEdit.swift
//  RecipeStocker
//
//  Created by ice_soi on 2019/12/29.
//  Copyright © 2019 ice_soi. All rights reserved.
//

import SwiftUI
import RealmSwift

struct RecipeEdit: View {
    @State var image: Image? = nil
    @State private var rect: CGRect = .zero
    @State var uiImage: UIImage? = nil
    @State var showCaptureImageView: Bool = false
    @State var name: String = ""
    @State var tag: String = ""
    @State var url: String = ""
    @ObservedObject private var myData = UserData()
    @State var isShown = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack {
                        HStack {
                            Text("レシピ")
                            Spacer()
                        }
                        TextField("",text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding(.horizontal, 10.0)
                    .font(Font.custom("HelveticaNeue-Light", size: 16.0))
                }
                HStack {
                    VStack {
                        HStack {
                            Text("検索タグ")
                            Spacer()
                        }
                        TextField("",text: $tag)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding(.horizontal, 10.0)
                    .font(Font.custom("HelveticaNeue-Light", size: 16.0))
                }
                HStack {
                    VStack {
                        HStack {
                            Text("URL")

                            Spacer()
                        }
                        TextField("",text: $url)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.URL)
                    }.padding(.horizontal, 10.0)
                    .font(Font.custom("HelveticaNeue-Light", size: 16.0))
                }
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text("コメント")
                            Spacer()
                        }
                        MultilineTextField( text: $myData.text)
                            .frame(height: 200.0)
                        }
                    Spacer()
                }
                HStack {
                    Button(action: {
                        self.showCaptureImageView.toggle()
                    }) {
                        Text("画像選択")
                    }.padding(.leading, 10.0)
                    Spacer()
                }
                HStack {
                    image?.resizable()
                      .frame(width: 120, height: 120)
                      .padding(.leading, 10.0)
                    .background(RectangleGetter(rect: $rect))
                    Spacer()
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            //Realmのインスタンス取得
                            do {
                                let realm = try Realm()
                                
                                let recipe = Recipe()
                                self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.rect)
                                recipe.image = self.uiImage!
                                recipe.name = self.name
                                recipe.tag = self.tag
                                recipe.url = self.url
                                recipe.remark = self.myData.text
                                try! realm.write {
                                    realm.add(recipe)
                                    self.isShown.toggle()
                                    print("成功だよ", recipe)
                                }
                            } catch {
                                print("エラーだよ")
                            }
                        })
                        {
                            Text("Save")
                        }.padding(.trailing, 10.0)
                            .alert(isPresented: self.$isShown) {
                                Alert(title: Text("レシピにのこしました"))
                        }
                    }
                }
                Spacer()
            }.navigationBarTitle(Text("レシピ登録"))
            if (showCaptureImageView) {
              CaptureImageView(isShown: $showCaptureImageView, image: $image)
            }
        }.onTapGesture {
            self.endEditing()
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

final class UserData: ObservableObject {
    @Published var text: String = ""
}


struct Edit_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEdit()
    }
}

struct MultilineTextField: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 7
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.borderWidth = 1
        view.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator : NSObject, UITextViewDelegate {

        var parent: MultilineTextField

        init(_ textView: MultilineTextField) {
            self.parent = textView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }

}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct RectangleGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            self.createView(proxy: geometry)
        }
    }

    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = proxy.frame(in: .global)
        }
        return Rectangle().fill(Color.clear)
    }
}

extension UIView {
    func getImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
