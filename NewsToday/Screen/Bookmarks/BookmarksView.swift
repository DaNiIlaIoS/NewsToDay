//
//  BookmarksView.swift
//  NewsToday
//
//  Created by Денис Гиндулин on 22.10.2024.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.bookmarks.isEmpty {
            EmptyBookmarks()
        } else {
            FilledBookmarks()
        }
    }
}

#Preview {
    BookmarksView()
        .environmentObject(LocalizationService())
        .environmentObject(AuthViewModel())
}