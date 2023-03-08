//
//  EditView.swift
//  BucketList
//
//  Created by Nick Pavlov on 3/7/23.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    @StateObject private var editModel = EditModel(location: .example)
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $editModel.name)
                    TextField("Description", text: $editModel.description)
                }
                
                // Performing nearby places for selected location
                Section("Nearby...") {
                    switch editModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(editModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = editModel.name
                    newLocation.description = editModel.description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await editModel.fetchNearbyPlaces()
            }
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
