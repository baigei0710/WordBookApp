//
//  MainUI.swift
//  WordBookApp
//
//  Created by baigeii on 2026/9/29.
//


//MARK: 主UI
import Foundation
import SwiftUI
import AppKit

private enum SidebarItem: Hashable {
    case wordBooks
    case book(UUID)
    case settings
}

private struct WordBookItem: Identifiable, Hashable {
    let id: UUID
    let name: String
}

struct MainUI: View {
    @State private var isSidebarVisible = true
    @State private var selection: SidebarItem?
    @State private var isWordBookExpanded = false
    @State private var wordBooks: [WordBookItem] = []
    private let sidebarWidth: CGFloat = 220

    var body: some View {
        HStack(spacing: 0) {
            if isSidebarVisible {
                sidebar
                    .frame(width: sidebarWidth)
                    .transition(.move(edge: .leading))
            }

            Color.white
        }
        .background(Color.white)
        .overlay(alignment: .topLeading) {
            toggleButton
        }
    }

    private var toggleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isSidebarVisible.toggle()
            }
        } label: {
            Image(systemName: "sidebar.left")
                .font(.system(size: 14, weight: .medium))
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .help(isSidebarVisible ? "收起边栏" : "展开边栏")
        .padding(.leading, 10)
        .padding(.top, 8)
    }

    private var sidebar: some View {
        List(selection: $selection) {
            DisclosureGroup(isExpanded: $isWordBookExpanded) {
                ForEach(wordBooks) { book in
                    Label(book.name, systemImage: "text.book.closed")
                        .tag(SidebarItem.book(book.id))
                }
            } label: {
                Label("单词本", systemImage: "book.closed")
                    .tag(SidebarItem.wordBooks)
            }
            Label("设置", systemImage: "gearshape")
                .tag(SidebarItem.settings)
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .padding(.top, 44)
        .background {
            ZStack {
                VisualEffectBackground(material: .sidebar)
                Color.gray.opacity(0.06)
            }
        }
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(Color.black.opacity(0.08))
                .frame(width: 1)
        }
    }
}

private struct VisualEffectBackground: NSViewRepresentable {
    let material: NSVisualEffectView.Material

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
    }
}

#Preview {
    MainUI()
        .frame(width: 1440, height: 900)
}

