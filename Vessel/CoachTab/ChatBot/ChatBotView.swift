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
    @State var textHeight: CGFloat = 100
    var footer: some View
    {
        HStack
        {
//            ScrollView
//            {
//                TextView(placeholder: viewModel.isProcessing ? "Violet is thinking..." : "Write a message...", text: self.$messageText, minHeight: self.textHeight, calculatedHeight: self.$textHeight)
//                    .frame(minHeight: self.textHeight, maxHeight: self.textHeight)
//            }
//            .frame(height: 60)
            TextField(viewModel.isProcessing ? "Violet is thinking..." : "Write a message...", text: $messageText)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .cornerRadius(30)
            
            HStack
            {
                Button
                {
                    if let id = conversationId
                    {
                        sendMessage(message: messageText, conversationId: id)
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
        .padding(.top, 23)
        .padding(.horizontal)
    }
    
    var body: some View
    {
        header
        VStack
        {
            ScrollView
            {
//                let modifiedDate = Calendar.current.date(byAdding: .hour, value: -2, to: today)!
                ForEach(viewModel.conversationHistory, id: \.self) { message in
                    let timestamp = time(createdAt: message.created_at)
                    let model = MessageModel(text: message.message, timestamp: Calendar.current.date(byAdding: .hour, value: -7, to: Date())!, isUserMessage: true)
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
    
    func sendMessage(message: String, conversationId: Int)
    {
        if message != "" {
            withAnimation
            {
                viewModel.addUserMessage(message)
                self.messageText = ""
            }
            viewModel.sendMessage(message, conversationId: conversationId)
        }
    }
    
    func time(createdAt: String) -> Date?
    {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "hh:mm:ss"
        let date = dateStringFormatter.date(from: createdAt)
        return date
    }
    
    var header: some View
    {
        HStack
        {
//            if viewModel.showBackButton
//            {
//                Button
//                {
//                    willMoveToNextScreen = false
//                } label:
//                {
//                    Image(systemName: "arrow.left")
//                        .foregroundColor(.black)
//                        .imageScale(.medium)
//                        .frame(width: 28, height: 28)
//                        .padding([.leading, .top, .bottom, .trailing], 15)
//                }
//            }
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

struct MessageModel: Codable, Hashable
{
    var text: String
    var timestamp: Date
    var isUserMessage: Bool
}

struct TextView: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String

    var minHeight: CGFloat
    @Binding var calculatedHeight: CGFloat

    init(placeholder: String, text: Binding<String>, minHeight: CGFloat, calculatedHeight: Binding<CGFloat>) {
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
        self._calculatedHeight = calculatedHeight
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator

        // Decrease priority of content resistance, so content would not push external layout set in SwiftUI
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
//        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)

        // Set the placeholder
        print("placeholder: \(placeholder)")
        textView.text = placeholder
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 14)

        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.text = self.text

        recalculateHeight(view: textView)
    }

    func recalculateHeight(view: UIView) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if minHeight < newSize.height && $calculatedHeight.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                self.$calculatedHeight.wrappedValue = newSize.height // !! must be called asynchronously
            }
        } else if minHeight >= newSize.height && $calculatedHeight.wrappedValue != minHeight {
            DispatchQueue.main.async {
                self.$calculatedHeight.wrappedValue = self.minHeight // !! must be called asynchronously
            }
        }
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textViewDidChange(_ textView: UITextView) {
            // This is needed for multistage text input (eg. Chinese, Japanese)
            if textView.markedTextRange == nil {
                parent.text = textView.text ?? String()
                parent.recalculateHeight(view: textView)
            }
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.lightGray
            }
        }
    }
}
