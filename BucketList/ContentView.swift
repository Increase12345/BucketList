//
//  ContentView.swift
//  BucketList
//
//  Created by Nick Pavlov on 3/5/23.
//
import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        Group {
            
            // Security check (if user was verified)
            if viewModel.isUnlocked {
                ZStack {
                    
                    // Map View
                    Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            VStack {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(Circle())
                                
                                Text(location.name)
                                    .fixedSize()
                            }
                            .onTapGesture {
                                viewModel.selectedPlace = location
                            }
                        }
                    }
                    .ignoresSafeArea()
                    
                    // Map annotation pointer
                    Circle()
                        .fill(.blue)
                        .opacity(0.3)
                        .frame(width: 32, height: 32)
                    
                    VStack {
                        Spacer()
                        HStack {
                            
                            // Remove Saved places button
                            Button {
                                viewModel.locations.removeAll()
                                viewModel.save()
                            } label: {
                                Image(systemName: "trash")
                                    .padding()
                                    .background(.black.opacity(0.75))
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .padding(.leading)
                            }
                            Spacer()
                            
                            // Add location button
                            Button {
                                viewModel.addLocation()
                            } label: {
                                Image(systemName: "plus")
                                    .padding()
                                    .background(.black.opacity(0.75))
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .padding(.trailing)
                            }
                        }
                    }
                }
                // Sheet to show the view of Edititing location
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) { newLocation in
                        viewModel.update(location: newLocation)
                    }
                }
                
                // Security check (if user was NOT verified)
            } else {
                VStack {
                    Spacer()
                    Button("Press to Unlock") {
                        viewModel.authenticate()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 3)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
            }
        }
        
        // Alert to show if youser was Not verified and why
        .alert("Error", isPresented: $viewModel.authenticateAlert) {
            Button("OK", action: { })
        } message: {
            Text(viewModel.authenticateAlertMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
