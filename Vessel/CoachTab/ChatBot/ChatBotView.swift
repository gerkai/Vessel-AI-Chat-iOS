//
//  ChatBotView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 9.8.23.
//

import SwiftUI

struct ChatBotView: View
{
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ChatBotViewModel
    
    @State private var messageText = ""
    @State var conversationId: Int?
    
    var footer: some View
    {
        HStack
        {
            ZStack(alignment: .leading)
            {
                TextEditor(text: $messageText)
                    .disabled(viewModel.isProcessing)
                    .cornerRadius(30)
                if messageText == ""
                {
                    Text(viewModel.isProcessing ? "Violet is thinking..." : "Write a message...")
                        .foregroundColor(.gray)
                        .padding(.bottom, 35)
                        .padding(.leading, 5)
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
                    let timestamp = time(createdAt: message.created_at)
                    let model = MessageModel(text: message.message,
                                             timestamp: timestamp ?? Date())
                    MessageView(messageModel: model, isUserMessage: message.role == "assistant")
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
    
    func time(createdAt: String) -> Date?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter.date(from: createdAt)
        return date
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
}

struct SystemMessageView: View
{
    var message: String
    var body: some View
    {
        Text(message)
            .font(.system(size: 16))
            .foregroundColor(.gray)
            .padding([.leading, .trailing], 25)
    }
}

struct MessageView: View
{
    var messageModel: MessageModel
    var showTime = false
    var isUserMessage: Bool
    
    var body: some View
    {
        VStack(alignment: isUserMessage ? .leading : .trailing)
        {
            Text("\(messageModel.timestamp.formatted(.dateTime.hour().minute()))")
                .font(.caption)
                .foregroundColor(.gray)
            HStack
            {
                Text(.init(messageModel.text))
                    .font(.system(size: 14))
                    .padding()
                    .foregroundColor(.black)
                    .background(isUserMessage ? .gray.opacity(0.2) : Color(uiColor: Constants.vesselChatGreen))
                    .cornerRadius(15)
            }
            .frame(maxWidth: 300, alignment: isUserMessage ? .leading : .trailing)
        }
        .frame(maxWidth: .infinity, alignment: isUserMessage ? .leading : .trailing)
        .padding(isUserMessage ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

struct MessageModel: Codable, Hashable
{
    var text: String
    var timestamp: Date
}
