//
//  RequestHealthKitAccessView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 11.9.23.
//

import SwiftUI

struct RequestHealthKitAccessView: View
{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let analytics = Resolver.resolve(Analytics.self)
    var body: some View
    {
        VStack
        {
            header
            Spacer()
            VStack(spacing: 10)
            {
                Text("After clicking Request Access below:")
                    .font(.custom("BananaGrotesk", size: 16))
                Text("Step 1 - tap \"All Categories On\"")
                    .font(.custom("BananaGrotesk", size: 16))
                Text("Step 2 - tap \"Allow\"")
                    .font(.custom("BananaGrotesk", size: 16))
                Button
                {
                    trackEventAuthStarted()
                    HealthKitManager.shared.authorizeHealthKit
                    { success, error in
                        guard error == nil else
                        {
                            return
                        }
                        trackEventAuthCompleted()
                        presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:
                        {
                            NotificationCenter.default.post(name: .chatbotDismissed, object: nil, userInfo: ["tab": Constants.TAB_BAR_TODAY_INDEX])
                        })
                    }
                } label:
                {
                    ZStack
                    {
                        Color(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .frame(height: 60)
                            .padding([.leading, .trailing], 30)
                        
                        Text("Request Access")
                            .foregroundColor(.white)
                            .font(.custom("BananaGrotesk-Bold", size: 16))
                    }
                }
            }
            
            Spacer()
        }
        .background(Color(uiColor: Constants.vesselHealthBg))
        .navigationBarBackButtonHidden(true)
    }
    
    var header: some View
    {
        HStack
        {
            Button
            {
                presentationMode.wrappedValue.dismiss()
            } label:
            {
                Image("square_back_button")
                    .foregroundColor(.black)
                    .imageScale(.medium)
                    .frame(width: 28, height: 28)
                    .padding(.leading, 30)
            }
            Spacer()
            Text("Connect")
                .padding(.leading, -50)
                .font(.custom("BananaGrotesk-Bold", size: 22))
            Spacer()
        }
    }
    
    private func trackEventAuthStarted()
    {
        analytics.log(event: .appleHealthAuthStarted)
    }
    
    private func trackEventAuthCompleted()
    {
          analytics.log(event: .appleHealthAuthCompleted)
    }
}

