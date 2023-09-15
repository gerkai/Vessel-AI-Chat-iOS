//
//  ConnectHealthKitView.swift
//  Vessel
//
//  Created by v.martin.peshevski on 11.9.23.
//

import SwiftUI

struct ConnectHealthKitView: View
{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isPresented = false
    var body: some View
    {
        VStack
        {
            header
            Spacer()
            VStack(spacing: 10)
            {
                HStack(spacing: 30)
                {
                    ZStack
                    {
                        Color(Constants.vesselGood)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(width: 65, height: 65)
                        Image("Logo")
                    }
                    Image("apple-health-logo")
                        .resizable()
                        .frame(width: 65, height: 65)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.gray, lineWidth: 0.5)
                            )
                }
                Text("Connect to Apple Health to improve your\n fitness, sleep and mindfulness minutes.")
                    .font(.custom("BananaGrotesk", size: 16))
                    .padding(20)
                Button(action: {
                    isPresented = true
                }, label: {
                    ZStack
                    {
                        Color(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .frame(height: 60)
                            .padding([.leading, .trailing], 30)
                        
                        Text("Continue")
                            .foregroundColor(.white)
                            .font(.custom("BananaGrotesk-Bold", size: 16))
                    }
                })
            }
            
            Spacer()
        }
        .background(Color(uiColor: Constants.vesselHealthBg))
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isPresented, content: RequestHealthKitAccessView.init)
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
            Text("Apple health")
                .padding(.leading, -50)
                .font(.custom("BananaGrotesk-Bold", size: 22))
            Spacer()
        }
    }
}
