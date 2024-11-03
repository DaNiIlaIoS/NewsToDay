//
//  FilledBookmarks.swift
//  NewsToday
//
//  Created by Даниил Сивожелезов on 31.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct FilledBookmarks: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var localizationService: LocalizationService
    
    @State private var selectedBookmark: Article? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HeaderTitle(title: Resources.Text.bookmarksTitle.localized(localizationService.language),
                            subtitle: Resources.Text.bookmarksText.localized(localizationService.language))
                List {
                    ForEach(authViewModel.bookmarks) { bookmark in
                        NavigationLink {
                            NewsCardView(article: bookmark)
                                .navigationBarBackButtonHidden()
                        } label: {
                            HStack {
                                if bookmark.imageURL != nil {
                                    WebImage(url: URL(string: bookmark.imageURL ?? ""))
                                        .resizable()
                                        .cornerRadius(12)
                                        .frame(width: 96, height: 96)
                                } else {
                                    Image(.empty)
                                        .resizable()
                                        .cornerRadius(12)
                                        .frame(width: 96, height: 96)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(bookmark.category?.first ?? "")
                                        .textCase(.uppercase)
                                        .interFont(type: .regular, size: 14)
                                        .foregroundStyle(.greyPrimary)
                                    
                                    Text(bookmark.title ?? "")
                                        .interFont()
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(3)
                                        .foregroundStyle(.blackPrimary)
                                }
                            }
                        }
                        
                    }
                    .onDelete(perform: deleteBookmark)
                    .onMove(perform: move)
                    .listRowSeparator(.hidden)
                }
                .padding(.top, 20)
                .padding(.bottom, 88)
                .listStyle(.plain)
            }
        }
    }
    
    func deleteBookmark(at offsets: IndexSet) {
        // Получаем закладки для удаления
        let bookmarksToDelete = offsets.map { authViewModel.bookmarks[$0] }
        
        // Удаляем закладки из локального массива
        authViewModel.bookmarks.remove(atOffsets: offsets)
        
        // Удаляем закладки из Firestore
        for bookmark in bookmarksToDelete {
            authViewModel.deleteBookmark(articleId: bookmark.id)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        authViewModel.bookmarks.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    FilledBookmarks()
        .environmentObject(AuthViewModel())
        .environmentObject(LocalizationService())
}