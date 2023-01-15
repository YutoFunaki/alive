//
//  ContentView.swift
//  alive
//
//  Created by 船木勇斗 on 2023/01/12.
//

import SwiftUI
import CoreData
import UIKit
import FSCalendar

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedDate: Date = Date()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationStack {
            VStack {
                Text("point")
            }
            
            
            TabView {
                DatePickerCalendar()
                    .tabItem {
                        Label("Home", systemImage: "calendar")
                            .padding()
                    }
                pointView()
                    .tabItem {
                        Label("交換", systemImage: "arrow.triangle.2.circlepath")
                            .padding()
                    }
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor(Color.indigo.opacity(0.2))
                appearance.shadowColor = UIColor(.indigo)
                appearance.backgroundEffect = UIBlurEffect(style: .extraLight)
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            .navigationBarTitle("alive")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: person()){
                        Image(systemName: "person.crop.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: frendView()) {
                        Image(systemName: "person.3")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct DatePickerCalendar: View {
    @State var selectedDate = Date()
    var omitTime: Bool = false
    var body: some View {
        VStack {
            Divider().frame(height: 1)
            DatePicker("Select Date", selection: $selectedDate,
                       in: ...Date(), displayedComponents: .date)
            .datePickerStyle(.graphical)
            Divider()
            Spacer()
            FormattedDate(selectedDate: selectedDate, omitTime: true)
            Text("やること")
            Spacer()
        }
    }
}

struct DatePickerCalendar_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerCalendar()
    }
}
