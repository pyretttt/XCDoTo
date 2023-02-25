////
//  ModalSheet.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 10.02.2023.
//

import SwiftUI

struct ModalSheet: View {
    
    @EnvironmentObject private var taskRepository: TaskRepository
    
    @State private var taskModel: TaskModel = .empty
    private let task: TaskModel
    private let sectionIdentifier: TaskSectionModel.ID
    
    // MARK: Lifecycle
    
    init(task: TaskModel, sectionIdentifier: TaskSectionModel.ID) {
        self.task = task
        self.sectionIdentifier = sectionIdentifier
    }

    // MARK: View
    
    var body: some View {
        VStack(alignment: .trailing) {
            LabelContent(label: "Title") {
                TextEditor(text: $taskModel.title)
                    .frame(width: 205, height: 28)
                    .padding(3)
                    .background(Color.textEditorColor)
                    .cornerRadius(6)
                    .cornerBorder(6, color: .gray.opacity(0.15))
            }
            Spacer()
            LabelContent(label: "Author") {
                TextEditor(text: $taskModel.author)
                    .frame(width: 205, height: 28)
                    .padding(3)
                    .background(Color.textEditorColor)
                    .cornerRadius(6)
                    .cornerBorder(6, color: .gray.opacity(0.15))
            }
            Spacer()
            LabelContent(label: "Release") {
                TextEditor(text: $taskModel.release)
                    .lineLimit(1)
                    .frame(width: 205, height: 16)
                    .padding(3)
                    .background(Color.textEditorColor)
                    .cornerRadius(6)
                    .cornerBorder(6, color: .gray.opacity(0.15))
            }
            Spacer()
            LabelContent(label: "Priority") {
                Menu {
                    ForEach(PriorityModel.allCases, id: \.self) { priority in
                        Button("\(priority.rawValue)") {
                            taskModel.priority = priority
                        }
                        Divider.appStyled()
                    }
                } label: {
                    Text(taskModel.priority.rawValue)
                        .background(Color.textEditorColor)
                        .cornerRadius(6)
                        .cornerBorder(6, color: .gray.opacity(0.15))
                }
                .frame(width: 205, height: 28)
                .padding(3)
            }
            
            Spacer()
            LabelContent(label: "Description") {
                TextEditor(text: $taskModel.taskDescription)
                    .frame(width: 205)
                    .padding(3)
                    .background(Color.textEditorColor)
                    .cornerRadius(6)
                    .cornerBorder(6, color: .gray.opacity(0.15))
            }
        }
        .foregroundColor(Color(nsColor: .fromHEX(0xD0CFD1)))
        .padding(14)
        .background(Color(nsColor: .fromHEX(0x211D26)))
        .border(Color(nsColor: .fromHEX(0x37333B)), width: 1)
        .frame(width: 305, height: 293)
        .onAppear {
            taskModel = task
        }
        .onDisappear {
            guard let sectionIndex = taskRepository.sections.firstIndex(where: { $0.id == sectionIdentifier }),
                  let taskIndex = taskRepository.sections[sectionIndex].tasks.firstIndex(where: { $0.id == taskModel.id }) else {
                return
            }
            var copySection = taskRepository.sections[sectionIndex]
            copySection.tasks[taskIndex] = taskModel.trimmed()
            taskRepository.editSection(copySection)
        }
    }
}
