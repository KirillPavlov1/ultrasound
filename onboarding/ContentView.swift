//
//  ContentView.swift
//  onboarding
//
//  Created by Кирилл on 26.08.2021.
//

import SwiftUI
import ApphudSDK
import StoreKit
import UserNotifications
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct FancyDotsIndexView: View {
  
  // MARK: - Public Properties
  let currentIndex: Int
  // MARK: - Drawing Constants
  
  private let circleSize: CGFloat = 9
  private let circleSpacing: CGFloat = 7
  
  private let primaryColor = Color.white
  private let secondaryColor = Color.white.opacity(0.6)
  
  private let smallScale: CGFloat = 0.6
  
  
  // MARK: - Body
  
  var body: some View {
    VStack{
    Spacer()
    ZStack(){
        Rectangle()
            .fill(
                LinearGradient(gradient: Gradient(colors: [ Color(red: 0.302, green: 0.765, blue: 1), Color(red: 0.173, green: 0.459, blue: 0.945)]), startPoint: .init(x: 0.25, y: 0.5), endPoint: .init(x: 0.75, y: 0.5))
                )
           
        
        VStack(){
            //Spacer()
            HStack(spacing: circleSpacing) {
                ForEach(0..<4) { index in // 1
                    Circle()
                        .fill(currentIndex == index ? primaryColor : secondaryColor) // 2
                        //.scaleEffect(currentIndex == index ? 1 : smallScale)
            
                        .frame(width: circleSize, height: circleSize)
       
                        .transition(AnyTransition.opacity.combined(with: .scale)) // 3
            
                        .id(index) // 4
                        }
                .padding(.top, 25)
                }
            Spacer()
            Spacer()
            Spacer()
            Button(action: {})
            {
                    Text("Continue")
                    .foregroundColor(Color(red: 0.096, green: 0.582, blue: 0.788))
                    
            }
            .frame(width: UIScreen.screenWidth * 0.85)
            .frame(height: 55.0)
            .background(Color.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .cornerRadius(12)
            .frame(alignment: .center)
            Spacer()
            Spacer()
            }
        
        }
    
    .frame(height: UIScreen.screenHeight * 0.27)
   
    }
    .edgesIgnoringSafeArea(.bottom)
  }
    
}

struct onBoarding: View {
    @State private var currentTab = 0
    @State private var text_button = "Continue"
    @StateObject var viewRouter: ViewRouter
    @State private var last = false
    private let circleSize: CGFloat = 9
    private let circleSpacing: CGFloat = 7
    private let primaryColor = Color.white
    private let secondaryColor = Color.white.opacity(0.6)
    private let smallScale: CGFloat = 0.6
    var obj = apphud()
    func `continue`()
    {
        var a: Bool
        if (currentTab < 3)
        {
            obj.configure()
            currentTab+=1
            if (currentTab == 2)
            {
                SKStoreReviewController.requestReview()
            }
            if (currentTab == 3)
            {
                text_button = "Continue & Subscribe"
                last.toggle()
            }
        }
        else
        {
            
            if (Apphud.hasActiveSubscription())
            {
                viewRouter.currentPage = .main
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
            else
            {
                obj.subscribeButtonAction()
            }
        }
    }
    
    var body: some View {
        ZStack{
        TabView(selection: $currentTab,
                        content:  {
                            ZStack{
                            Rectangle()
                                .fill(Color.white)
                                    .edgesIgnoringSafeArea(.all)
                            Image("onboarding1")
                                .resizable()
                                .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.85)
                            }
                                .tag(0)
                            ZStack{
                            Rectangle()
                                .fill(Color.white)
                                    .edgesIgnoringSafeArea(.all)
                            Image("onboarding2")
                                .resizable()
                                .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.9)
                            }
                                .tag(1)
                            ZStack{
                            Rectangle()
                                .fill(Color.white)
                                    .edgesIgnoringSafeArea(.all)
                            Image("onboarding3")
                                .resizable()
                                .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.9)
                            }
                                .tag(2)
                            ZStack{
                            Rectangle()
                                .fill(Color.white)
                                    .edgesIgnoringSafeArea(.all)
                            Image("onboarding4")
                                .resizable()
                                //.padding()
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                            }
                                .tag(3)
                        })
        VStack{
        Spacer()
        ZStack(){
            Rectangle()
                .fill(
                    LinearGradient(gradient: Gradient(colors: [ Color(red: 0.302, green: 0.765, blue: 1), Color(red: 0.173, green: 0.459, blue: 0.945)]), startPoint: .init(x: 0.5, y: 0.5), endPoint: .init(x: 0.5, y: 1))
                    )
               
            
            VStack(){
                //Spacer()
                HStack(spacing: circleSpacing) {
                    ForEach(0..<4) { index in // 1
                        Circle()
                            .fill(currentTab == index ? primaryColor : secondaryColor) // 2
                            .frame(width: circleSize, height: circleSize)
                            .transition(AnyTransition.opacity.combined(with: .scale)) // 3
                            .id(index) // 4
                            }
                    .padding(.top, 20)
                    }
                Spacer()
                Spacer()
                Spacer()
                Button(action: {self.continue()})
                {
                        Text(text_button)
                        .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight / 17)
                        .foregroundColor(Color(red: 0.096, green: 0.582, blue: 0.788))
                        
                }
                .frame(width: UIScreen.screenWidth * 0.85)
                .frame(height: UIScreen.screenHeight / 17)
                .background(Color.init(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .cornerRadius(12)
                .frame(alignment: .center)
                Spacer()
                if (obj.trialperiod != nil && last)
                {
                    Text("Trial period for \(String(obj.trialperiod)) then \(String(obj.Price))")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                else if (last)
                {
                    Text("Billed every \(String(obj.subperiod)) at \(String(obj.Price))")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                Spacer()
                HStack{
                        Link("Privacy Policy", destination: URL(string: "http://cbdapps-srl.tilda.ws/privacypolicy")!)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                        Text("     |   ")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                        Button(action: {obj.restore_product()})
                        {
                            Text("Restore")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                        }
                        Text("   |     ")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                        Link("Terms Of Use", destination: URL(string: "http://cbdapps-srl.tilda.ws/termsofuse")!)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
                Spacer()
              //  Spacer()
              //  Spacer()
             
                }
            
            }
        
        .frame(height: UIScreen.screenHeight * 0.27)
       
        }
        .edgesIgnoringSafeArea(.bottom)
           // .overlay(FancyDotsIndexView(currentIndex: currentTab))
            //.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
      
        
    }
    }
}

struct onBoarding_Previews: PreviewProvider {
    static var previews: some View {
        onBoarding(viewRouter: ViewRouter())
    }
}

enum Page {
    case onBoarding
    case main
}

class ViewRouter: ObservableObject {
    var a = Apphud.hasActiveSubscription()
    @Published var currentPage: Page = Apphud.hasActiveSubscription() ? .main : .onBoarding
}

struct MotherView: View{
    
    @StateObject var viewRouter: ViewRouter
    var body: some View{
        switch viewRouter.currentPage {
        case .onBoarding:
            onBoarding(viewRouter: viewRouter)
        case .main:
            main(viewRouter: viewRouter)
    }
    }
}

struct MotherView_Previews: PreviewProvider {

    static var previews: some View {
        MotherView(viewRouter: ViewRouter())
    }
}


extension SKProductSubscriptionPeriod {
    public var localizedDescription: String {
            let period:String = {
                switch self.unit {
                case .day: return "day"
                case .week: return "week"
                case .month: return "month"
                case .year: return "year"
                @unknown default:
                    return "unknown period"
                }
            }()
        
            let plural = numberOfUnits > 1 ? "s" : ""
            return "\(numberOfUnits) \(period)\(plural)"
        }
}

class apphud{
    
    private var product: ApphudProduct!
    private var title: String?
    private var subtitle: String?
    private var subunits: Int?
    var Price: String!
    var subperiod: String!
    var trialperiod: String!
    
    func configure() {
        configureProduct()
        subperiod =  product.skProduct?.subscriptionPeriod?.localizedDescription
        trialperiod = product.skProduct?.introductoryPrice?.subscriptionPeriod.localizedDescription
        let numberFormatter = NumberFormatter()
        let locale = product.skProduct?.priceLocale
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        Price = numberFormatter.string(from:  product.skProduct!.price)
    }
    func subscribeButtonAction() {
        // 4 - Делаем покупку
        Apphud.purchase(product) { result in
            if let subscription = result.subscription, subscription.isActive(){
               // has active subscription
            } else if let purchase = result.nonRenewingPurchase, purchase.isActive(){
               // has active non-renewing purchase
            } else {
               // handle error or check transaction status.
            }
        }
    }
    func restore_product(){
        Apphud.restorePurchases{ subscriptions, purchases, error in
           if Apphud.hasActiveSubscription(){
             // has active subscription
           } else {
             // no active subscription found, check non-renewing purchases or error
           }
        }
    }
    
    func configureProduct() {
        // - 3. Конфигурируем apphud product
        Apphud.getPaywalls { [weak self] (paywalls, _) in // - 3.1 - Берем все пэйволы
            if let paywall = paywalls?.last { // - 3.2 - Берем нужный нам пэйвол(last - после - пэйвол, first - первый и т.д.)
                guard let product = paywall.products.first else { // - 3.3 - проверяем есть ли покупка
                   // self?.dismiss(animated: true, completion: nil)
                    return
                }
                self?.product = product
                let json = paywall.json // - 3.4 - Берем json который создавали в apphud

                self?.title = json?["title"] as? String
                self?.subtitle = json?["subtitle"] as? String

            } else {
              //  self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
