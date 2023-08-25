//
//  ChatBotIntro.swift
//  Vessel
//
//  Created by Martin Peshevski on 8/23/23.
//

import SwiftUI

struct ChatBotIntro2: View
{
    var itemList: some View
    {
        VStack (alignment: .leading)
        {
            HStack
            {
                Image("question")
                Text(.init("Answer her questions"))
                    .font(.system(size: 14))
                    .padding(.top, 16)
                    .padding(.bottom, 12)
            }
            HStack
            {
                Image("test")
                Text(.init("Take a Vessel pee test"))
                    .font(.system(size: 14))
                    .padding([.top, .bottom], 12)
            }
            HStack
            {
                Image("apple-bite")
                Text(.init("Connect Apple Health"))
                    .font(.system(size: 14))
                    .padding([.top, .bottom], 12)
            }
            HStack
            {
                Image("blood")
                Text(.init("Add a blood test, DNA report, etc"))
                    .font(.system(size: 14))
                    .padding([.top, .bottom], 12)
            }
        }
        .padding([.leading, .trailing], 51)
    }
    
    var leftAlignedContent: some View
    {
        HStack
        {
            VStack(alignment: .leading)
            {
                Text("Some ways to teach her about you:")
                    .font(.system(size: 14))
                itemList
            }
            Spacer()
        }
        .padding(.top, 24)
        .padding(.leading, 16)
    }
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            Image("violet-circle")
                .padding([.top, .bottom], 24)
            Text("Personalized to you")
                .font(.system(size: 35, weight: .semibold))
                .padding(.bottom, 8)
            Text("The more you teach violet about you,\n the more helpful she will be.")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
            leftAlignedContent
            Spacer()
            NavigationLink(destination: ChatBotIntro3())
            {
                ZStack
                {
                    Color(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .frame(height: 60)
                        .padding([.leading, .trailing], 30)
                    
                    Text("Got it!")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
