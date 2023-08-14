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
    
    var body: some View
    {
        header
        NavigationView
        {
            List
            {
                startChatButton
                Spacer()
                ForEach(viewModel.conversations.reversed(), id: \.self)
                { conversation in
                    NavigationLink
                    {
                        ChatBotView(viewModel: viewModel, conversationId: conversation.id)
                    } label: {
                        Text("# \(conversation.id)")
                    }
                }
            }
            .background(.clear)//(Color(uiColor: Constants.vesselChatGreen))
        }
        .onAppear
        {
            viewModel.getConversations()
        }
        .navigate(to: ChatBotView(viewModel: viewModel, conversationId: nil), when: $willMoveToNextScreen)
    }
    
    var header: some View
    {
        HStack
        {
//            if viewModel.showBackButton
//            {
//                Button
//                {
//                    willMoveToNextScreen = false
//                } label:
//                {
//                    Image(systemName: "arrow.left")
//                        .foregroundColor(.black)
//                        .imageScale(.medium)
//                        .frame(width: 28, height: 28)
//                        .padding([.leading, .top, .bottom, .trailing], 15)
//                }
//            }
            Spacer()
            VStack(alignment: .center)
            {
                Text("Vessel nutritionist")
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
        .frame(minHeight: 60)
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
