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
                HStack(spacing: 0)
                {
                    Text(.init("Nutritionist"))
                        .font(.custom("BananaGrotesk-Semibold", size: 14))
                    Text(.init(" - Meal & grocery plan"))
                        .font(.custom("NoeText", size: 14))
                }
                .padding(.bottom, 12)
                .padding(.top, 16)
            }
            HStack
            {
                Image("weight")
                HStack(spacing: 0)
                {
                    Text(.init("Trainer"))
                        .font(.custom("BananaGrotesk-Semibold", size: 14))
                    Text(.init(" - Fitness & weight loss plan"))
                        .font(.custom("NoeText", size: 14))
                }
                .padding([.top, .bottom], 12)
            }
            HStack
            {
                Image("pill")
                HStack(spacing: 0)
                {
                    Text(.init("Functional Dr"))
                        .font(.custom("BananaGrotesk-Semibold", size: 14))
                    Text(.init(" - Supplement plan"))
                        .font(.custom("NoeText", size: 14))
                }
                .padding([.top, .bottom], 12)
            }
            HStack
            {
                Image("happy")
                HStack(spacing: 0)
                {
                    Text(.init("Therapist"))
                        .font(.custom("BananaGrotesk-Semibold", size: 14))
                    Text(.init(" - Mental health plan"))
                        .font(.custom("NoeText", size: 14))
                }
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
                    .font(.custom("NoeText", size: 14))
                itemList
                Text("And she can answer health questions.")
                    .font(.custom("NoeText", size: 14))
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
                    .padding(.bottom, 8)
                    .font(.custom("BananaGrotesk-Semibold", size: 35))
                Text("Your personal wellness coach.")
                    .font(.custom("NoeText", size: 16))
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
                            .font(.custom("BananaGrotesk-Bold", size: 16))
                    }
                }
            }
        }
        .padding(.top, -20)
        .navigationBarBackButtonHidden()
    }
}
