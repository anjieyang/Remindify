//
//  ContentView.swift
//  Remindify
//
//  Created by digmouse on 2023-05-03.
//

import SwiftUI

struct HomeView: View {
    @FetchRequest(sortDescriptors: [])
    private var myListsResults: FetchedResults<MyList>
    
    @FetchRequest(sortDescriptors: [])
    private var searchResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: RemindifyService.getRemindersByStatType(reminderStatType: .today))
    private var todayResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: RemindifyService.getRemindersByStatType(reminderStatType: .scheduled))
    private var scheduledResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: RemindifyService.getRemindersByStatType(reminderStatType: .all))
    private var allResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: RemindifyService.getRemindersByStatType(reminderStatType: .completed))
    private var completedResults: FetchedResults<Reminder>
    
    @State private var isPresented: Bool = false
    @State private var search: String = ""
    @State private var isSearching: Bool = false
    @State private var today: String = ""
    
    private var reminderStatsBuilder: ReminderStatsBuilder = ReminderStatsBuilder()
    @State private var reminderStatsValues: ReminderStatsValues = ReminderStatsValues()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    HStack {
                        NavigationLink {
                            ReminderListView(reminders: todayResults)
                        } label: {
                            ReminderStatsView(icon: "\(Date().dayInString).circle.fill", title: "Today", count: reminderStatsValues.todayCount, iconColor: .blue)
                        }

                        NavigationLink {
                            ReminderListView(reminders: scheduledResults)
                        } label: {
                            ReminderStatsView(icon: "calendar.circle.fill", title: "Scheduled", count: reminderStatsValues.scheduledCount, iconColor: .red)
                        }

                    }
                    
                    HStack {
                        NavigationLink {
                            ReminderListView(reminders: allResults)
                        } label: {
                            ReminderStatsView(icon: "tray.circle.fill", title: "All", count: reminderStatsValues.allCount, iconColor: .gray)
                        }

                        NavigationLink {
                            ReminderListView(reminders: completedResults)
                        } label: {
                            ReminderStatsView(icon: "checkmark.circle.fill", title: "Completed", count: reminderStatsValues.completedCount, iconColor: .green)
                        }

                    }
                    
                    Text("My Lists")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title3)
                        .bold()
                        .padding()
                    
                    MyListsView(myLists: myListsResults)
                    
                    Button {
                        isPresented = true
                    } label: {
                        Text("Add List")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    }
                }
                .sheet(isPresented: $isPresented) {
                    NavigationView {
                        AddNewListView { listName, color in
                            do {
                                try RemindifyService.saveMyList(name: listName, color: color)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .onChange(of: search, perform: { searchTerm in
                    isSearching = !searchTerm.isEmpty ? true : false
                    searchResults.nsPredicate = RemindifyService.getRemindersBySearchTerm(searchTerm: search).predicate
                })
                .overlay(alignment: .center, content: {
                    ReminderListView(reminders: searchResults)
                        .opacity(isSearching ? 1.0 : 0.0)
                })
                .padding()
            .navigationTitle("Remindify")
            }
            .onAppear {
                reminderStatsValues = reminderStatsBuilder.build(myListResults: myListsResults)
            }
        }
        .searchable(text: $search)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}
