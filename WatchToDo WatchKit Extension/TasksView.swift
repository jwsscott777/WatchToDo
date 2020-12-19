//
//  TasksView.swift
//  WatchToDo WatchKit Extension
//
//  Created by JWSScott777 on 12/18/20.
//
import CoreData
import SwiftUI

struct TasksView: View {
    var sampleTasks = [
    "Task One", "Task Two", "Task Three"
    ]
    var rowHeight: CGFloat = 50
    @State private var newTaskTitle = ""
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(entity: ToDoItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.createdAt, ascending: false)], predicate: NSPredicate(format: "taskDone = %d", false), animation: .default)
    
    var fetchedItems: FetchedResults<ToDoItem>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fetchedItems, id: \.self) { item in
                    HStack {
                        Text(item.taskTitle ?? "Empty")
                            .foregroundColor(.orange)
                        Spacer()
                      
                            Button(action: {
                                markTaskAsDone(at: fetchedItems.firstIndex(of: item)!)
                            }) {
                            Image(systemName: "circle")
                                .imageScale(.large)
                                .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(height: rowHeight)
                HStack {
                    TextField("Add Task..", text: $newTaskTitle, onCommit: {
                        saveTask()
                    })
                    Button(action: {
                        saveTask()
                    }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .foregroundColor(.green)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(height: rowHeight)
               
                NavigationLink(destination: TasksDoneView()) {
                Text("Tasks Done")
                    .foregroundColor(.blue)
                    .frame(height: rowHeight)
                }
            }// :list
            .navigationTitle("Welds to do")
        }// : nav
        
    }
    
    func saveTask() {
        guard self.newTaskTitle != "" else {
            return
        }
        let newToDoItem = ToDoItem(context: viewContext)
        newToDoItem.taskTitle = newTaskTitle
        newToDoItem.createdAt = Date()
        newToDoItem.taskDone = false
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        newTaskTitle = ""
    }
    
    func markTaskAsDone(at index: Int) {
        let item = fetchedItems[index]
        item.taskDone = true
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
