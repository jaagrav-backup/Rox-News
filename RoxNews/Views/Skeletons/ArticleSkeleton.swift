//
//  ArticleSkeleton.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 02/03/26.
//

import SwiftUI

struct ArticleSkeleton: View {
    @State private var isPulsing = false

    var body: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(.secondary)
            .frame(height: 240)
            .opacity(isPulsing ? 0.5 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
        HStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(.secondary)
                .frame(height: 20)
            RoundedRectangle(cornerRadius: 18)
                .fill(.secondary)
                .frame(height: 20)
            RoundedRectangle(cornerRadius: 18)
                .fill(.secondary)
                .frame(height: 20)
        }
        HStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(.secondary)
                .frame(height: 20)
            RoundedRectangle(cornerRadius: 18)
                .fill(.secondary)
                .frame(height: 20)
            RoundedRectangle(cornerRadius: 18)
                .fill(.secondary)
                .frame(height: 20)
        }
    }
}

#Preview {
    ArticleSkeleton()
}
