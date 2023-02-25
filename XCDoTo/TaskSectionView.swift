////
//  TaskSectionView.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 23.02.2023.
//

import SwiftUI

struct TaskSectionView: View {
    
    @EnvironmentObject private var taskRepository: TaskRepository
    @State private var isHovered = false
    @State private var title = ""
    @FocusState private var titleFocus: Bool
    @Binding private var sectionUnderEdit: TaskSectionModel.ID?
    
    private let model: TaskSectionModel
    
    init(sectionModel: TaskSectionModel, sectionUnderEdit: Binding<TaskSectionModel.ID?>) {
        self.model = sectionModel
        self._sectionUnderEdit = sectionUnderEdit
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Button {
                updateSectionInRepository { $0.isDisclosed.toggle() }
            } label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white.opacity(0.8))
                    .rotationEffect(model.isDisclosed ? .radians(Double.pi / 2) : .zero)
                    .animation(.easeIn(duration: 0.15), value: model.isDisclosed)
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(.borderless)
            
            Image(systemName: "folder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 16, height: 16)
            
            TextField("Project Title", text: $title)
                .textFieldStyle(.plain)
                .disabled(sectionUnderEdit != model.id)
                .focused($titleFocus, equals: true)
                .onSubmit {
                    updateSectionInRepository { $0.title = title }
                    titleFocus = false
                    sectionUnderEdit = nil // Disables editing of section
                }
                .onChange(of: titleFocus) { isFocused in
                    if !isFocused {
                        updateSectionInRepository { $0.title = title }
                        sectionUnderEdit = nil // Disables editing of section
                    }
                }
        }
        .padding(12)
        .font(.system(size: 12, weight: .medium))
        .foregroundColor(Color(nsColor: .fromHEX(0xFFFFFF).withAlphaComponent(0.8)))
        .background(isHovered ? Color.accentBlue : Color.clear)
        .animation(.default, value: isHovered)
        .onHover {
            isHovered = $0
        }
        .onAppear {
            title = model.title
        }
    }
    
    // MARK: Data
    
    private func updateSectionInRepository(_ mutation: (inout TaskSectionModel) -> Void) {
        guard var section = taskRepository.sections.first(where: { $0.id == model.id }) else {
            assert(false, "Unexpected data inconsistency, cannot find section with id: \(model.id)")
        }
        mutation(&section)
        taskRepository.editSection(section)
    }
}
