//
//  ChatBotListView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 14.8.23.
//

import SwiftUI

struct ChatBotListView: View
{
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ChatBotViewModel
    @State private var willMoveToNextScreen = false
    @State private var selectedItem: Int? = nil
    var body: some View
    {
        header
        VStack(spacing: 0)
        {
            NavigationView
            {
                List
                {
                    startChatButton
                    Spacer()
                    ForEach(viewModel.conversations.sorted(by: { $0.id > $1.id }), id: \.self)
                    { conversation in
                        HStack
                        {
                            Text("# \(conversation.id)")
                                .onTapGesture
                            {
                                self.selectedItem = conversation.id
                            }
                            .background(
                                NavigationLink(destination: ChatBotView(viewModel: viewModel, conversationId: conversation.id), tag: conversation.id,
                                               selection: $selectedItem) { EmptyView() }
                                    .opacity(0)
                            )
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .font(Font.system(.caption).weight(.bold))
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                        }
                        .accentColor(Color(uiColor: Constants.vesselChatGreen))
                    }
                    .listRowBackground(Color(uiColor: Constants.vesselChatGreen))
                }
                .listStyle(.plain)
                .background(Color(uiColor: Constants.vesselChatGreen))
            }
            .onAppear
            {
                viewModel.getConversations()
            }
            .navigate(to: ChatBotView(viewModel: viewModel, conversationId: nil), when: $willMoveToNextScreen)
        }
        .padding(.top, -20)
    }
    
    var header: some View
    {
        HStack
        {
            if viewModel.showBackButton
            {
                Button
                {
                    willMoveToNextScreen = false
                    selectedItem = nil
                } label:
                {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .imageScale(.medium)
                        .frame(width: 28, height: 28)
                        .padding([.leading, .top, .bottom, .trailing], 15)
                }
            }
            Spacer()
            VStack(alignment: .center)
            {
                Text("Violet - AI Wellness Coach")
                .foregroundColor(.black)
                .bold()
            }
            Spacer()
            Button
            {
                presentationMode.wrappedValue.dismiss()
            } label:
            {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .imageScale(.medium)
                    .frame(width: 28, height: 28)
                    .padding([.top, .bottom, .trailing], 15)
            }
        }
        .background(Color(uiColor: Constants.vesselChatGreen))
        .frame(minHeight: 80)
        .offset(y: -20)
    }
    
    public var startChatButton: some View
    {
        Button
        {
            willMoveToNextScreen = true
        } label:
        {
            Text("Start chat")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 48)
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.black)
        )
    }
}

extension View
{
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View
    {
        NavigationView
        {
            ZStack
            {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                )
                {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
