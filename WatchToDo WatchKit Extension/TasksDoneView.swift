//
//  TasksDoneView.swift
//  WatchToDo WatchKit Extension
//
//  Created by JWSScott777 on 12/18/20.
//

import SwiftUI

struct TasksDoneView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(entity: ToDoItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.createdAt, ascending: false)], predicate: NSPredicate(format: "taskDone = %d", true), animation: .default)
    
    var fetchedItems: FetchedResults<ToDoItem>
    var rowHeight: CGFloat = 50
    var body: some View {
        List {
                ForEach(fetchedItems, id: \.self) { item in
                    HStack {
                            Text(item.taskTitle ?? "Empty")
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                            .frame(height: rowHeight)
                }
                .onDelete(perform: removeItems)
            }
        .navigationBarTitle(Text("Welds Done"))
        
    }
    
    private func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let item = fetchedItems[index]
            viewContext.delete(item)
        }
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TasksDoneView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        TasksDoneView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
