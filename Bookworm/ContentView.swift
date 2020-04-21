//
//  ContentView.swift
//  Bookworm
//
//  Created by Юрий Станиславский on 16.04.2020.
//  Copyright © 2020 Yuri Stanislavsky. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true),
        NSSortDescriptor(keyPath: \Book.genre, ascending: true),
    ]) var books: FetchedResults<Book>

    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        VStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            Text("Rating")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }

                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title")
                                .foregroundColor(book.rating == 1 ? Color.red : .primary)
                                .font(.headline)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            .onDelete(perform: deleteBooks)
            }
            .navigationBarTitle("Bookworm")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddScreen.toggle()
            }) {
//                Image(systemName: "plus")
                Text("New book")
            })
            .sheet(isPresented: $showingAddScreen) {
                AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        
        if moc.hasChanges {
            try? moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
