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
    @State var points: Int = Int()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationStack {
            VStack {
                Text("\(points) P")
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
            // 下のタブバーの設定
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor(Color.indigo.opacity(0.2))
                appearance.shadowColor = UIColor(.indigo)
                appearance.backgroundEffect = UIBlurEffect(style: .extraLight)
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            // 上のタブバーの設定
            .navigationBarTitle("alive")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: person()){
                        Image(systemName: "person.crop.circle")
                    }
                }
                //ToolbarItem(placement: .navigationBarTrailing) {
                    //NavigationLink(destination: frendView()) {
                        //Image(systemName: "person.3")
                    //}
                //}
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
    @State private var ruckyes = ["大吉":"今日こそ課題を終わらせよう！", "大大吉":"今日はなんでも上手くいく。", "超大吉":"マジすごい", "極大吉":"今日は神様と同じ存在だよ。", "超極大吉":"今日は生きているだけで崇められそう！"]
    var omitTime: Bool = false
    var body: some View {
        VStack {
            Divider().frame(height: 1)
            DatePicker("Select Date", selection: $selectedDate,
                       in: ...Date(), displayedComponents: .date)
            .datePickerStyle(.graphical)
            Divider()
            //FormattedDate(selectedDate: selectedDate, omitTime: true)
            Text("今日の運勢は")
            Spacer()
            HStack {
                Image(systemName: "party.popper.fill")
                    .foregroundColor(.yellow)
                    .rotation3DEffect(.degrees(180),
                                      axis: (x: 0, y: 1, z: 0))
                Text(ruckyes.keys)
                    .foregroundColor(.red)
                Image(systemName: "party.popper.fill")
                    .foregroundColor(.yellow)
            }
            .font(.largeTitle)
            
            Spacer()
            Text("今日も頑張ろう！")
                .padding()
        }
    }
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent:DatePickerCalendar
                
        let eventsDate = [
            Date(),
            Calendar.current.date(byAdding: .day, value: +1, to: Date())!,
            Calendar.current.date(byAdding: .day, value: +5, to: Date())!
        ]
        
        let dateFormatter = DateFormatter()
        
        init(_ parent:DatePickerCalendar){
            self.parent = parent
        }
 
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            
            dateFormatter.dateFormat = "MMM dd, yyyy"
            for eventDate in eventsDate{
                guard let eventDate = dateFormatter.date(from: dateFormatYMD(date: eventDate)) else { return 0 }
                if date.compare(eventDate) == .orderedSame{
                    return 1
                }
            }
            return 0
        }
        
        func dateFormatYMD(date: Date) -> String {
            let df = DateFormatter()
            df.dateStyle = .long
            df.timeStyle = .none
            
            return df.string(from: date)
        }
    }
}

struct DatePickerCalendar_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerCalendar()
    }
}

