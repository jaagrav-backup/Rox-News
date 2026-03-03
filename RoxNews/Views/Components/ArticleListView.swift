//
//  ArticleListView.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 01/03/26.
//

import SwiftUI

enum NewsType {
    case all
    case headlines
}

struct CreditsView: View {
    var article: Article
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Authored by")
                    .font(.caption2)
                Text(article.author ?? "Anonymous")
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack(alignment: .leading) {
                Text("Source")
                    .font(.caption2)
                Text(article.source?.name ?? "God")
            }
            .frame(maxWidth: .infinity)
            Spacer()
            VStack(alignment: .leading) {
                Text("Published on")
                    .font(.caption2)
                Text(ISO8601DateFormatter().date(from: article.publishedAt) ?? Date(), format: .dateTime.day().month().year())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct NoArticlesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.transmission")
                .font(.largeTitle)
            Text("No articles found, try modifying your filters")
                .multilineTextAlignment(.center)
        }
        .opacity(0.6)
        .frame(maxWidth: 250)
    }
}

struct ErrorLoadingArticlesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.icloud")
                .font(.largeTitle)
            Text("Couldn't fetch articles, maybe check your network connection")
                .multilineTextAlignment(.center)
        }
        .opacity(0.6)
        .frame(maxWidth: 250)
    }
}

struct ArticleListItemView: View {
    var article: Article
    
    var body: some View {
        NavigationLink {
            ArticleDetailScreenView(article: article)
        } label: {
            VStack {
                VStack {
                    AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                        switch phase {
                        case .empty:
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.secondary.opacity(0.4))
                                .frame(height: 250)
                                .overlay {
                                    ProgressView()
                                }
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(24)
                                .frame(maxWidth: .infinity)
                            
                        case .failure:
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.secondary.opacity(0.4))
                                .frame(height: 250)
                                .overlay {
                                    Image(systemName: "exclamationmark.icloud.fill")
                                }
                            
                        default:
                            EmptyView()
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .bold()
                        .font(.title3)
                    if article.description != nil {
                        Text(article.description ?? "")
                            .font(.footnote)
                    }
                    
                    CreditsView(article: article)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationLinkIndicatorVisibility(.hidden)
    }
}

struct ArticleListView: View {
    @StateObject var filtersManager = FiltersManager.shared
    @StateObject var articleManager = ArticleManager.shared
    
    var body: some View {
        Group {
            if articleManager.isError && !articleManager.isLoading {
                ErrorLoadingArticlesView()
            } else if articleManager.list.isEmpty && !articleManager.isLoading {
                NoArticlesView()
            } else {
                List {
                    if articleManager.isLoading {
                        ArticleSkeleton()
                        ArticleSkeleton()
                        ArticleSkeleton()
                    } else {
                        ForEach(articleManager.list, id: \.url) { article in
                            ArticleListItemView(article: article)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .refreshable {
                    print("called from article list")
                    await articleManager.fetchArticles()
                }
            }
        }
    }
}
