//
//  ChatBotIntro3.swift
//  Vessel
//
//  Created by Martin Peshevski on 8/23/23.
//

import SwiftUI

struct ChatBotIntro3: View
{
    var body: some View
    {
        VStack(spacing: 0)
        {
            Image("violet-circle")
                .padding([.bottom, .top], 24)
            Text("Disclaimer")
                .font(.system(size: 35, weight: .semibold))
                .padding(.bottom, 24)
            Text("Violet is an AI that provides information based on widely accepted health and wellness practices as of its last training cut-off in September 2021.\n\nIt is not intended to replace professional medical advice, diagnosis, or treatment.\n\nAlways seek the advice of your physician or another qualified health provider with any questions you may have regarding a medical condition, medication, nutritional supplement, or exercise regimen.\n\nNever disregard professional medical advice or delay in seeking it because of something you have read on this app.")
                .font(.system(size: 14))
                .padding([.leading, .trailing], 16)
            Spacer()
            NavigationLink(destination: ChatBotView(viewModel: ChatBotViewModel()))
            {
                ZStack
                {
                    Color(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .frame(height: 60)
                        .padding([.leading, .trailing], 30)
                    
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
