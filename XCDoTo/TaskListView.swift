////
//  TaskListView.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 06.02.2023.
//

import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject private var repository: TaskRepository
    @EnvironmentObject private var settingsFacade: SettingsFacade
    
    // MARK: State
    
    @State private var sectionInFocus: TaskSectionModel.ID? = nil
    @State private var sectionUnderEdit: TaskSectionModel.ID? = nil
    @State private var shownItem: TaskModel? = nil
    @State private var emptyItem: TaskModel? = nil
    
    // MARK: View
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    let sections = repository.searchPattern.isEmpty ? repository.sections : repository.searchedSection()
                    ForEach(sections, id: \.id) { section in
                        let tasks: [TaskModel] = section.isDisclosed ? section.tasks : []
                        TaskSectionView(sectionModel: section, sectionUnderEdit: $sectionUnderEdit)
                            .overlay(alignment: .leading) {
                                if sectionInFocus == section.id {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(.white)
                                        .opacity(0.8)
                                        .frame(width: 3)
                                        .padding(4)
                                }
                            }
                            .onTapGesture {
                                // Enables/Disables editing of section. Requires 2 taps on the same section
                                sectionUnderEdit = sectionInFocus == section.id ? section.id : nil
                                sectionInFocus = section.id
                            }
                        
                        ForEach(tasks, id: \.id) { task in
                            TaskCell(task: task) {
                                var sectionCopy = section
                                sectionCopy.tasks = sectionCopy.tasks.filter { $0.id != task.id }
                                repository.editSection(sectionCopy)
                            }
                            .onTapGesture {
                                shownItem = task
                                sectionInFocus = section.id
                                sectionUnderEdit = nil // Disables editing of section
                            }
                            .popover(item: shownItem == task ? $shownItem : $emptyItem, arrowEdge: .trailing) { task in
                                ModalSheet(task: task, sectionIdentifier: section.id)
                            }
                        }
                    }
                }
            }
            .task {
                repository.load()
            }
            
            Divider.appStyled()
            
            HStack {
                Button {
                    guard let sectionInFocus else { return }
                    sectionUnderEdit = nil // Disables editing of section
                    shownItem = repository.createNewTask(sectionIdentifier: sectionInFocus)
                } label: {
                    Image(systemName: "plus")
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                }
                .disabled(sectionInFocus == nil)
                .buttonStyle(.borderless)
                
                TextEditor(text: $repository.searchPattern) // Probably need to add disabling of section editing
                    .frame(height: 18)
                    .padding([.top], 4)
                    .background(Color(nsColor: .fromHEX(0x5C5A5F)))
                    .cornerRadius(6)
                    .overlay {
                        if repository.searchPattern.isEmpty {
                            Text("Filter")
                                .foregroundColor(Color(nsColor: .fromHEX(0x918F94)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading], 6)
                        }
                    }
            }
            .padding(8)
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
