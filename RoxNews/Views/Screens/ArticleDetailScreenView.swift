//
//  ArticleDetailScreenView.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 01/03/26.
//

import SwiftUI
import FoundationModels

struct AIGeneratedSummary: View {
    var article: Article
    var session = LanguageModelSession()
    
    @State var summarisedText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if summarisedText.isEmpty {
                    Text("Summarising content using Apple Intelligence...")
                        .opacity(0.6)
                }
                Text(summarisedText)
                    .multilineTextAlignment(.leading)
                    .font(.title2)
                Spacer()
                if !session.isResponding {
                    Text("Generated using Apple Intelligence")
                        .font(.caption)
                        .opacity(0.6)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle("AI Summary")
            .navigationBarTitleDisplayMode(.inline)
            .padding(24)
        }
        .presentationDetents([.medium])
        .task {
            await generateSummary()
        }
    }
    
    func generateSummary() async {
        let prompt = """
            You are news summariser. Summarise the news in 50-60 words with the following context.
            Title: \(article.title)
            Description: \(article.description ?? "No description")
            Content: \(article.content ?? "No content")
            Author: \(article.author ?? "Anonymous")
            """
        
        let resp = session.streamResponse(to: prompt)
        
        do {
            for try await partial in resp {
                withAnimation {
                    summarisedText = partial.content
                }
            }
        } catch {
            print(error)
        }
    }
}

struct ArticleDetailScreenView: View {
    @State var showSummaryScreen: Bool = false
    var article: Article
    
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(.secondary.opacity(0.4))
                        .frame(height: 250)
                        .overlay {
                            ProgressView()
                        }
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                    
                case .failure:
                    Rectangle()
                        .fill(.secondary.opacity(0.4))
                        .frame(height: 250)
                        .overlay {
                            Image(systemName: "exclamationmark.icloud.fill")
                        }
                    
                default:
                    EmptyView()
                }
            }
            .backgroundExtensionEffect()
            .safeAreaPadding(.top, 500)
            .padding(.top, -420)
            
            VStack {
                Text(article.title)
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)
                CreditsView(article: article)
                    .padding(.top, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 18)
            
            if article.description != nil {
                Text(article.description ?? "")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)
                    .padding(.horizontal, 18)
                    .opacity(0.6)
            }
            
            if article.content != nil {
                Text(article.content ?? "")
                    .font(.default)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)
                    .padding(.horizontal, 18)
            }
            
            Spacer()
            
            Link(destination: URL(string: article.url)!) {
               HStack {
                   Image(systemName: "link")
                   Text("Read complete article on \(article.source?.name ?? "God")")
                       .padding(.vertical, 12)
               }
               .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .padding(18)
            .padding(.bottom, 32)
        }
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
        .scrollEdgeEffectStyle(.soft, for: .top)
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
        .toolbar {
            if SystemLanguageModel.default.isAvailable {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Summary", systemImage: "text.line.3.summary") {
                        showSummaryScreen = true
                    }
                }
            }
        }
        .sheet(isPresented: $showSummaryScreen) {
            AIGeneratedSummary(article: article)
        }
    }
}

