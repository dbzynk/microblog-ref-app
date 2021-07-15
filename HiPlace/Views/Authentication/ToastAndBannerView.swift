//
//  ToastAndBannerView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 4.06.2021.
//

import SwiftUI

func ToastAndBannerView(title: String, detail: String, showBanner: Binding<Bool>, showToast: Binding<Bool>) -> some View {
    Group {
        ToastView(title: title, showToast: showToast)
        BannerView(title: title, detail: detail, showBanner: showBanner)
    }
}

func ToastView(title: String, showToast: Binding<Bool>) -> some View {
    HStack {Spacer()}
        .overlay(overlayView: toastView(title: title, showToast), show: showToast)
        .zIndex(100.0)
}

func BannerView(title: String, detail: String, showBanner: Binding<Bool>) -> some View {
    HStack {Spacer()}
        .overlay(overlayView: bannerView(title: title, detail: detail, showBanner), show: showBanner)
        .zIndex(100.0)
}

private func bannerView(title: String, detail: String, _ showBanner: Binding<Bool>) -> some View {
    return Banner(data: Banner.BannerDataModel(title: title, detail: detail, type: .success), show: showBanner)
        .padding(.horizontal, 40)
}

private func toastView(title: String, _ showToast: Binding<Bool>) -> some View {
    return Toast(dataModel: Toast.ToastDataModel(title: title, image: "checkmark"), show: showToast)
}

struct Banner: View {

   struct BannerDataModel {
       var title:String
       var detail:String
       var type: BannerType
   }
   
   enum BannerType {
       case info
       case warning
       case success
       case error
       
       var tintColor: Color {
           switch self {
           case .info:
            return .blue
           case .success:
               return .green
           case .warning:
               return .yellow
           case .error:
               return .red
           }
       }
    
    var sfSymbol: String {
        switch self {
        case .info:
         return "info.circle"
        case .success:
            return "checkmark.seal"
        case .warning:
            return "exclamationmark.octagon"
        case .error:
            return "xmark.octagon"
        }
    }
   }
    let data: BannerDataModel
    @Binding var show: Bool
    var body: some View {
        VStack {
                HStack {
                    Image.init(systemName: data.type.sfSymbol)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(data.title)
                            .bold()
                        Text(data.detail)
                            .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                    }
                    Spacer()
                }
                .foregroundColor(Color.white)
                .padding(12)
                .background(data.type.tintColor)
                .cornerRadius(8)
                Spacer()
            }
            .padding()
            .animation(.easeInOut)
            .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            .onTapGesture {
                withAnimation {
                    self.show = false
                }
            }.onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.show = false
                    }
                }
            })
    }
}

struct Toast: View {
    
    struct ToastDataModel {
        var title:String
        var image:String
        
    }
    let dataModel: ToastDataModel
    @Binding var show: Bool
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: dataModel.image)
                Text(dataModel.title)
            }.font(.headline)
            .foregroundColor(.primary)
                .padding([.top,.bottom],20)
                .padding([.leading,.trailing],40)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(Capsule())
        }
        .frame(width: UIScreen.main.bounds.width / 1.25)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                self.show = false
            }
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.show = false
                }
            }
        })
    }
}

struct Overlay<T: View>: ViewModifier {
    
    @Binding var show: Bool
    let overlayView: T
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                overlayView
            }
        }
    }
}

extension View {
    func overlay<T: View>( overlayView: T, show: Binding<Bool>) -> some View {
        self.modifier(Overlay.init(show: show, overlayView: overlayView))
    }
}


struct OverlayDemo: View {
     @State private var showOverlay = false
    @State private var showToastOverlay = false
    var body: some View {
        VStack {
            Button(action: {
                showOverlay = true
            }, label: {
                Text("Show Banner!")
            })
            .padding()
//            Text("Show Banner!")
//                .onTapGesture {
//                    withAnimation {
//                        showOverlay = true
//                    }
//                }
            
            Text("Show Toast!")
                .onTapGesture {
                    withAnimation {
                        showToastOverlay = true
                    }
                }
        }.overlay(overlayView: Banner.init(data: Banner.BannerDataModel(title: "Title", detail: "your message", type: .success), show: $showOverlay)
                  , show: $showOverlay)
        .overlay(overlayView: Toast.init(dataModel: Toast.ToastDataModel.init(title: "toast message", image: "checkmark"), show: $showToastOverlay)
        , show: $showToastOverlay)
        
    }
}

struct OverlayDemo_Previews: PreviewProvider {
    static var previews: some View {
        OverlayDemo()
    }
}
