//
//  ChatBotView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 9.8.23.
//

import SwiftUI

extension NSNotification.Name
{
    static let chatbotDismissed = Notification.Name.init("chatbotDismissed")
}

struct ChatBotView: View
{
    @ObservedObject var viewModel: ChatBotViewModel
    
    @State private var messageText = ""
    @State var conversationId: Int?
    @State var isLoading: Bool = false
    @State var isStreaming: Bool = false
    @FocusState private var focusedField: Bool
    
    var header: some View
    {
        HStack
        {
            Menu(content: {
                startChatButton
                ForEach(viewModel.conversations.sorted(by: { $0.id > $1.id }), id: \.self)
                    { conversation in
                        Button("# \(conversation.id)", action: {
                            openChat(conversation: conversation.id)
                        })
                    }
            }, label: {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.black)
                    .imageScale(.medium)
                    .frame(width: 28, height: 28)
                    .padding([.leading, .top, .bottom, .trailing], 15)
            })
            Spacer()
            VStack(alignment: .center)
            {
                Text("Wellness Coach")
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
            isLoading = true
            Task
            {
                conversationId = await viewModel.startChat()
                isLoading = false
            }
        } label:
        {
            Label("Start chat", systemImage: "plus")
        }
    }
    
    var footer: some View
    {
        HStack
        {
            ZStack(alignment: .leading)
            {
                TextEditor(text: $messageText)
                    .disabled(viewModel.isProcessing)
                    .frame(width: .infinity, height: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 1)
                    )
                    .focused($focusedField)
                if messageText == ""
                {
                    Text(viewModel.isProcessing ? "Violet is thinking..." : "Write a message...")
                        .disabled(true)
                        .foregroundColor(.gray)
                        .padding(.bottom, 35)
                        .padding(.leading, 5)
                        .onTapGesture
                        {
                            if viewModel.isProcessing
                            {
                                focusedField = false
                            }
                            else
                            {
                                focusedField = true
                            }
                        }
                }
                else
                {
                    Text(messageText)
                        .opacity(0)
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                }
            }
            .frame(maxHeight: 80)
            HStack
            {
                Button
                {
                    if let id = conversationId
                    {
                        Task
                        {
                             await sendMessage(message: messageText, conversationId: id)
                        }
                    }
                } label: {
                    ZStack
                    {
                        Circle()
                            .frame(width: 38, height: 38)
                            .foregroundColor(isStreaming ? .gray.opacity(0.2) : Color(Constants.vesselChatGreen))
                        Image(systemName: "paperplane")
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .padding(.top, 8)
        .padding(.horizontal)
    }
    
    var body: some View
    {
        LoadingView(isShowing: $isLoading)
        {
            VStack(spacing: 1)
            {
                header
                ZStack(alignment: .bottomTrailing)
                {
                    ScrollView
                    {
                        ForEach(viewModel.conversationHistory, id: \.self) { message in
                            let timestamp = viewModel.time(createdAt: message.created_at)
                            let model = MessageModel(text: message.message,
                                                     timestamp: timestamp ?? Date())
                            MessageView(messageModel: model, isAssistant: message.role == "assistant")
                        }
                        .rotationEffect(.degrees(180))
                    }
                    .rotationEffect(.degrees(180))
                    .padding(.top, -24)
                    
                    Button
                    {
                        
                    } label: {
                         Image(systemName: "heart.square")
                             .font(.title.weight(.semibold))
                             .padding()
                             .background(Color.pink)
                             .foregroundColor(.white)
                             .clipShape(Circle())
                             .shadow(radius: 4, x: 0, y: 4)
                     }
                     .padding()
                }
                Divider()
                footer
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear
        {
            isLoading = true
            if Server.shared.chatToken == nil
            {
                Task
                {
                    await handleChatAuth()
                }
            }
            else
            {
                Task
                {
                    conversationId = await viewModel.startChat()
                    isLoading = false
                }
                viewModel.getConversations()
            }
        }
    }
    
    func sendMessage(message: String, conversationId: Int) async
    {
        if message != "" {
            withAnimation
            {
                viewModel.addUserMessage(message)
                self.messageText = ""
                isStreaming = true
            }
            do
            {
                try await viewModel.streamMessage(message, conversationId: conversationId)
                isStreaming = false
            }
            catch
            {
                isStreaming = false
                print("streamMessage catch")
            }
        }
    }
    
    private func handleChatAuth() async
    {
        if let contact = Contact.main(), let firstName = contact.first_name, let lastName = contact.last_name
        {
            let username = String((firstName + lastName).prefix(15))
            viewModel.login(username: username, completion: { result in
                switch result
                {
                case .success:
                    Task
                    {
                        conversationId = await viewModel.startChat()
                        isLoading = false
                        viewModel.getConversations()
                    }
                case .invalidCredentials:
                    viewModel.signup(username: username, completion: { success in
                        if success
                        {
                            Task
                            {
                                conversationId = await viewModel.startChat()
                                viewModel.getConversations()
                            }
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
    
    func openChat(conversation id: Int)
    {
        viewModel.getConversationHistory(id)
    }
}
