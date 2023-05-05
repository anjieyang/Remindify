//
//  SelectListView.swift
//  Remindify
//
//  Created by digmouse on 2023-05-04.
//

import SwiftUI

struct SelectListView: View {
    @Binding var selectedList: MyList?
    
    @FetchRequest(sortDescriptors: [])
    private var myListFetchedResult: FetchedResults<MyList>
    
    var body: some View {
        List(myListFetchedResult) { myList in
            HStack {
                HStack {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .foregroundColor(Color(myList.color))
                    Text(myList.name)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedList = myList
                }
                
                if selectedList == myList {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct SelectListView_Previews: PreviewProvider {
    static var previews: some View {
        SelectListView(selectedList: .constant(PreviewData.myList))
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}
