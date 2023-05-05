//
//  MyListsView.swift
//  Remindify
//
//  Created by digmouse on 2023-05-03.
//

import SwiftUI

struct MyListsView: View {
    let myLists: FetchedResults<MyList>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            if myLists.isEmpty {
                Spacer()
                Text("No reminder list found")
            } else {
                ForEach(myLists) { myList in
                    NavigationLink(value: myList) {
                        VStack {
                            MyListCellView(myList: myList)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading], 10)
                                .font(.title3)
                                .foregroundColor(colorScheme == .dark ? Color.offWhite : Color.darkGray)
                            Divider()
                        }
                    }
                    .listRowBackground(colorScheme == .dark ? Color.darkGray : Color.offWhite)
                }
                .scrollContentBackground(.hidden)
                .navigationDestination(for: MyList.self) { myList in
                    // TODO: Change the color of the navigation title based on the list color
                    MyListDetailView(myList: myList)
                        .navigationTitle(myList.name)
                }
            }
        }
    }
}
