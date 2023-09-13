//
//  MessageView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 11.9.23.
//

import SwiftUI

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
                    
                    Text("Violet")
                        .font(.caption)
                        .foregroundColor(.gray)
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
