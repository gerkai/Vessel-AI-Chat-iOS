//
//  ChatBotIntro.swift
//  Vessel
//
//  Created by Martin Peshevski on 8/23/23.
//

import SwiftUI

struct ChatBotIntro: View
{
    var itemList: some View
    {
        VStack (alignment: .leading)
        {
            HStack
            {
                Image("apple")
                Text(.init("**Nutritionist** - Meal & grocery plan"))
                    .font(.system(size: 14))
                    .padding(.bottom, 12)
                    .padding(.top, 16)
            }
            HStack
            {
                Image("weight")
                Text(.init("**Trainer** - Fitness & weight loss plan"))
                    .font(.system(size: 14))
                    .padding([.top, .bottom], 12)
            }
            HStack
            {
                Image("pill")
                Text(.init("**Functional Dr** - Supplement plan"))
                    .font(.system(size: 14))
                    .padding([.top, .bottom], 12)
            }
            HStack
            {
                Image("happy")
                Text(.init("**Therapist** - Mental health plan"))
                    .font(.system(size: 14))
                    .padding(.top, 12)
                    .padding(.bottom, 16)
            }
        }
        .padding([.leading, .trailing], 39)
    }
    
    var leftAlignedContent: some View
    {
        HStack
        {
            VStack(alignment: .leading)
            {
                Text("She is a powerful AI that can be your...")
                    .font(.system(size: 14))
                itemList
                Text("And she can answer health questions.")
                    .font(.system(size: 14))
            }
            Spacer()
        }
        .padding(.top, 24)
        .padding(.leading, 17)
    }
    
    var body: some View
    {
        NavigationView
        {
            VStack(spacing: 0)
            {
                Image("violet-circle")
                    .padding([.top, .bottom], 24)
                Text("Meet Violet")
                    .font(.system(size: 35, weight: .semibold))
                    .padding(.bottom, 8)
                Text("Your personal welness coach.")
                    .font(.system(size: 16))
                leftAlignedContent
                Spacer()
                NavigationLink(destination: ChatBotIntro2())
                {
                    ZStack
                    {
                        Color(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .frame(height: 60)
                            .padding([.leading, .trailing], 30)
                        
                        Text("Cool!")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
            }
        }
        .padding(.top, -20)
        .navigationBarBackButtonHidden()
    }
}

struct ChatBotIntro_Previews: PreviewProvider
{
    static var previews: some View
    {
        ChatBotIntro()
    }
}
