//
//  ChatBotListView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 14.8.23.
//

import SwiftUI

struct ChatBotListView: View
{
    @ObservedObject var viewModel: ChatBotViewModel
    @State private var willMoveToNextScreen = false
    @State private var selectedItem: Int? = nil
    @State var isLoading: Bool = false
    
    var body: some View
    {
        header
        VStack(spacing: 0)
        {
            LoadingView(isShowing: $isLoading)
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
                isLoading = true
                if Server.shared.chatToken == nil
                {
                    handleChatAuth()
                }
                else
                {
                    viewModel.getConversations()
                    isLoading = false
                }
            }
            .navigate(to: ChatBotView(viewModel: viewModel, conversationId: nil), when: $willMoveToNextScreen)
        }
        .navigationBarBackButtonHidden(true)
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
                    viewModel.conversationHistory.removeAll()
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
                NotificationCenter.default.post(name: .chatbotDismissed, object: nil)
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
    
    private func handleChatAuth()
    {
        if let contact = Contact.main(), let firstName = contact.first_name, let lastName = contact.last_name
        {
            let username = String((firstName + lastName).prefix(15))
            viewModel.login(username: username, completion: { result in
                switch result
                {
                case .success:
                    viewModel.getConversations()
                    isLoading = false
                case .invalidCredentials:
                    viewModel.signup(username: username, completion: { success in
                        if success
                        {
                            willMoveToNextScreen = true
                        }
                        else
                        {
                            print("login error")
                        }
                        isLoading = false
                    })
                case .error:
                    print("login error")
                    isLoading = false
                }
            })
        }
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

struct ActivityIndicator: UIViewRepresentable
{
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView
    {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>)
    {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View
{
    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View
    {
        GeometryReader { geometry in
            ZStack(alignment: .center)
            {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack
                {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}
