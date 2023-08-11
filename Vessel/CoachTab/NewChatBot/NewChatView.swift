//
//  NewChatView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 9.8.23.
//

import SwiftUI

struct NewChatView: View
{
    @Environment(\.presentationMode) var presentationMode
    
    @State private var messageText = ""
    @ObservedObject var viewModel: ChatViewModel
    
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
    
    var footer: some View
    {
        HStack
        {
            TextField("Write a message...", text: $messageText)
                .foregroundColor(.black)
                .frame(height: 54)
                .padding(.horizontal, 20)
                .cornerRadius(30)
            
            HStack
            {
                Button
                {
                    print("Attach")
                } label: {
                    ZStack
                    {
                        Circle()
                            .frame(width: 38, height: 38)
                            .foregroundColor(.gray)
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.white)
                    }
                }
                Button
                {
                    sendMessage(message: messageText)
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
        .padding(.top, 23)
        .padding(.horizontal)
    }
    
    var body: some View
    {
        VStack
        {
            header
            ScrollView
            {
                ForEach(viewModel.messages) { message in
                    if message.isSystemMessage
                    {
                        SystemMessageView(message: message.text)
                    }
                    else
                    {
                        MessageView(messageModel: message, isUserMessage: message.isUserMessage)
                            .padding(.bottom, 10)
                    }
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
            viewModel.startChat()
        }
    }
    
    func sendMessage(message: String)
    {
        if message != "" {
            withAnimation
            {
                let message = MessageModel(id: "\(viewModel.messages.count)", text: messageText, timestamp: Date(), isUserMessage: viewModel.messages.count > 1, isSystemMessage: viewModel.messages.count == 5)
                viewModel.messages.append(message)
                self.messageText = ""
            }
        }
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
                Text(messageModel.text)
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

struct MessageModel: Identifiable, Codable, Hashable
{
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool
    {
        return lhs.id == rhs.id
    }
    
    var id: String
    var text: String
    var timestamp: Date
    var isUserMessage: Bool
    var isSystemMessage: Bool
}
