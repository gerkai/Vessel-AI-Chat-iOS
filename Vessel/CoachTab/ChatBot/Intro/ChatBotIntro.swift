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
                    .padding([.top, .bottom], 12)
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
                    .padding([.top, .bottom], 12)
            }
        }
        .padding([.leading, .trailing])
    }
    
    var leftAlignedContent: some View
    {
        VStack(alignment: .leading)
        {
            Text("She is a powerful AI that can be your...")
                .font(.system(size: 14))
            itemList
            Text("And she can answer health questions.")
                .font(.system(size: 14))
        }
        .padding(.top, 24)
        .padding(.leading, -30)
    }
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                Image("violet-circle")
                Text("Meet Violet")
                    .font(.system(size: 35, weight: .semibold))
                Text("Your personal welness coach.")
                    .font(.system(size: 16))
                leftAlignedContent
                Spacer()
                NavigationLink(destination: ChatBotIntro2())
                {
                    ZStack
                    {
                        Color(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(height: 60)
                            .padding([.leading, .trailing], 50)
                        
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
