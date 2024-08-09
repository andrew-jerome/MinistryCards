//
//  TagsView.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//

import SwiftUI

struct TagsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: []) var tags: FetchedResults<Tag>
    
    @State private var tagName = ""
    
    @State private var addTag = false
    
    var body: some View {
        List {
            ForEach(tags) { tag in
                Text(tag.name ?? "Unknown")
            }
            .onDelete(perform: deleteTag)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    addTag = true
                } label: {
                   Label("Add Tag", systemImage: "plus")
                }
            }
        }
        .alert("Create new small group", isPresented: $addTag) {
            TextField("Small Group Name", text: $tagName)
            Button("Submit", action: submitTag)
            Button("Cancel", role: .cancel) { }
        }
    }
    
    func submitTag() {
        let newTag = Tag(context: viewContext)
        newTag.id = UUID()
        newTag.name = tagName
        
        tagName = ""
        
        try? viewContext.save()
    }
    
    func deleteTag( at offsets : IndexSet) {
        for offset in offsets {
            let tagToRemove = tags[offset]
            viewContext.delete(tagToRemove)
        }
        try? viewContext.save()
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView()
    }
}

