//
//  ChatBotView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 9.8.23.
//

import SwiftUI

extension NSNotification.Name {
    static let chatbotDismissed = Notification.Name.init("chatbotDismissed")
}

struct ChatBotView: View
{
    @ObservedObject var viewModel: ChatBotViewModel
    
    @State private var messageText = ""
    @State var conversationId: Int?
    @FocusState private var focusedField: Bool
    
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
                            .foregroundColor(.gray)
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
        VStack
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
            Divider()
            footer
        }
        .navigationBarBackButtonHidden(true)
        .background()
        .ignoresSafeArea(.all)
        .padding(.vertical)
        .background(.clear)
        .onAppear
        {
            viewModel.showBackButton = true
            if let id = conversationId
            {
                viewModel.getConversationHistory(id)
            } else
            {
                viewModel.startChat
                { id in
                    self.conversationId = id
                }
            }
        }
        .onDisappear
        {
            viewModel.showBackButton = false
        }
    }
    
    func sendMessage(message: String, conversationId: Int) async
    {
        if message != "" {
            withAnimation
            {
                viewModel.addUserMessage(message)
                self.messageText = ""
            }
            do
            {
                try await viewModel.streamMessage(message, conversationId: conversationId)
            }
            catch
            {
                print("streamMessage catch")
            }
        }
    }
    
    var header: some View
    {
        HStack
        {
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
        .frame(minHeight: 60)
        .offset(y: -20)
    }
}

struct MessageView: View
{
    var messageModel: MessageModel
    var showTime = false
    var isAssistant: Bool
    
    var body: some View
    {
        VStack(alignment: isAssistant ? .leading : .trailing)
        {
            HStack
            {
                if isAssistant
                {
                    Image("chat-bot-avatar")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .cornerRadius(6)
                }
                else
                {
                    if let firstName = Contact.main()?.first_name
                    {
                        Text(firstName)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Text("\(messageModel.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            HStack
            {
                Text(.init(messageModel.text))
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.black)
                    .background(isAssistant ? .gray.opacity(0.2) : Color(uiColor: Constants.vesselChatGreen))
                    .cornerRadius(15)
            }
            .frame(maxWidth: 300, alignment: isAssistant ? .leading : .trailing)
        }
        .frame(maxWidth: .infinity, alignment: isAssistant ? .leading : .trailing)
        .padding(isAssistant ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

struct MessageModel: Codable, Hashable
{
    var text: String
    var timestamp: Date
}
