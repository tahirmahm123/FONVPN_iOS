/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view for bridging a UIPageViewController.
*/

import SwiftUI
import Foundation

struct PageView<Page: View>: View {
    var pages: [Page]
    @State var timer: Timer?
    @State private var currentPage = 0

    var body: some View {
        VStack(spacing: 0) {
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
//                .frame(width: CGFloat(pages.count * 18))
//                .padding(.trailing)
        }
        .background(Color.clear)
        .onAppear {
            print("PageView Appeared")
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
        
    }
    
    func startTimer() {
        $timer.wrappedValue = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            if $currentPage.wrappedValue == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    $currentPage.wrappedValue = 0
                }
            } else {
                $currentPage.wrappedValue = $currentPage.wrappedValue + 1
            }
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(pages: (0...2).map {
            LoginPageControl(index: $0)
        })
        .background(ZStack {
            LinearGradient(colors: [Color("SecondaryGradientColor1"), Color("SecondaryGradientColor2")], startPoint: .leading, endPoint: .trailing)
            Image("Background")
        })
    }
}
