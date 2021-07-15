//
//  RefreshScrollView.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 28.06.2021.
//

import SwiftUI

struct RefreshScrollView<Content: View>: View {
    // Refresh ScrollView with SwiftUI approach
    
    @State var refresh = Refresh(started: false, released: false)
    var progressTint = Color(.label)
    var arrowTint = Color(.label)
    var content: Content
    var onUpdate: (_ onCompletion: @escaping ()->Void)->Void
    var contentRefreshThreshOld :DispatchTime  { return .now() + 7 } // seconds
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            // geometry reader for calculating position...
            
            GeometryReader { reader -> AnyView in
                DispatchQueue.main.async {
                    if refresh.startOffset == 0 {
                        refresh.startOffset = reader.frame(in: .global).minY
                    }
                    refresh.offset = reader.frame(in: .global).minY
                    
                    if refresh.offset - refresh.startOffset > 90 && !refresh.started {
                        refresh.started = true
                    }
                    
                    // checking if refresh is started and drag is released....
                    if refresh.startOffset == refresh.offset && refresh.started  && !refresh.released {
                        withAnimation(Animation.linear) {
                            refresh.released = true
                        }
                        fireUpdate()
                    }
                    
                    //checking if invalid becomes valid
                    if refresh.startOffset == refresh.offset && refresh.started  && refresh.released && refresh.invalid {
                        refresh.invalid = false
                        fireUpdate()
                    }
                }
                
                return AnyView(Color.black.frame(width: 0, height: 0))
            }
            .frame(width: 0, height: 0)
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                // Arrow And Indicator...
                if refresh.started && refresh.released {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: progressTint))
                        .offset(y: -32)
                }
                else {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(nil)
                        .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                        .offset(y: -30)
                        .animation(.easeIn)
                        .opacity(refresh.offset != refresh.startOffset ? 1 : 0)
                }
                
                VStack {
                    content
                }
                .frame(maxWidth: .infinity)
            }
            .offset(y: refresh.released ? 40 : -10)
        }
    }

    func fireUpdate() {
        if refresh.startOffset == refresh.offset {
            onUpdate(endRefresh)
        
            // if no data comes, end refreshing
            DispatchQueue.main.asyncAfter(deadline: contentRefreshThreshOld) {
                if refresh.startOffset == refresh.offset {
                    endRefresh()
                }
            }
        } else {
            withAnimation(Animation.linear) {
                refresh.invalid = true
            }
        }
    }
    
    func endRefresh() {
        withAnimation(Animation.linear) {
            refresh.released = false
            refresh.started = false
        }
    }
    
    struct Refresh {
        var startOffset: CGFloat = 0
        var offset: CGFloat = 0
        var started: Bool
        var released: Bool
        var invalid: Bool = false
    }
}


struct OldRefreshScrollView<Content: View>: UIViewRepresentable {
    // REfresh ScrollView with UIKit approach

    var content: Content
    var onRefresh: (UIRefreshControl) -> ()
    var refreshControl = UIRefreshControl()
    
    var refresherTitle = "Loading..."
    var refresherTintColor: UIColor = .label
    
    // View Builder to capture SwiftUI View...
    init(@ViewBuilder content: @escaping () -> Content, onRefresh: @escaping (UIRefreshControl) -> ()) {
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let uiscrollView = UIScrollView()
        
        // Refresh Control...
        refreshControl.attributedTitle = NSAttributedString(string: refresherTitle)
        refreshControl.tintColor = refresherTintColor
        refreshControl.addTarget(context.coordinator, action: #selector(context.coordinator.onRefresh), for: .valueChanged)
        
        // Since we are removing the last subview..
        // so it will remove refresh control
        // so add after setting up view...
        
        setupView(uiscrollView: uiscrollView)
        uiscrollView.refreshControl = refreshControl

        return uiscrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Because view is not updating dynamically...
        // Update View Dynamically...
        setupView(uiscrollView: uiView)
    }
    
    func setupView(uiscrollView: UIScrollView) {
        // Extracting SwiftUI View...
        // Moving View Up...
        let hostViewController = UIHostingController(rootView: content.frame(maxHeight: .infinity, alignment: .top))
        
        // We are going to constraints System from UIKit...
        // So that no need of width and height calculations...
        hostViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Clipping the SwiftUI view to UIKit View
        let constraints = [
            // Four Corners...
            hostViewController.view.topAnchor.constraint(equalTo: uiscrollView.topAnchor),
            hostViewController.view.bottomAnchor.constraint(equalTo: uiscrollView.bottomAnchor),
            hostViewController.view.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
            hostViewController.view.trailingAnchor.constraint(equalTo: uiscrollView.trailingAnchor),
            
            // Size...
            hostViewController.view.widthAnchor.constraint(equalTo: uiscrollView.widthAnchor),
            // For Bouncing...
            hostViewController.view.heightAnchor.constraint(greaterThanOrEqualTo: uiscrollView.heightAnchor, constant: 1)
        ]
        
        // Removing Previously Added View...
        uiscrollView.subviews.last?.removeFromSuperview()
        uiscrollView.addSubview(hostViewController.view)
        uiscrollView.addConstraints(constraints)
    }
    
    class Coordinator: NSObject {
        var parent: OldRefreshScrollView
        init(parent: OldRefreshScrollView) {
            self.parent = parent
        }
        
        @objc func onRefresh() {
            parent.onRefresh(parent.refreshControl)
        }
    }
}
