import Foundation
import NVActivityIndicatorView
import SnapKit
import UIKit

class ProductDetailsHeaderView: UIView {
    static let headerViewRadius: CGFloat = 10

    private let containerView = UIView()

    private let btPremiumAvailableOnly = ButtonLabelCustomView()

    private let btIsNextProduct = ButtonLabelCustomView()
    private let btExclusiveProduct = ButtonLabelCustomView()
    private let btExclusiveProductForSubscriber = ButtonLabelCustomView()
    private let lbTitle = UILabel()
    private let lbTypeAndInfo = UILabel()
    private let btNotification = UIButton(type: .custom)

    private var isNextProduct = false
    private var notificationsOn = false {
        didSet {
            if notificationsOn {
                btNotification.setImage(UIImage(named: "NotificationOff"), for: .normal)
            } else {
                btNotification.setImage(UIImage(named: "NotificationOn"), for: .normal)
            }
        }
    }

    private var refScreen: UBDomainReferenceScreen?

    private weak var spacingViewBetweenTopButtonAndLbTitle: Constraint?
    private weak var spacingViewBetweenTopButtonAndSuperview: Constraint?

    private lazy var topButtonStackview: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [btPremiumAvailableOnly, btIsNextProduct, btExclusiveProduct, btExclusiveProductForSubscriber])
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()

    private var product: UBDomainProduct?

    private var subscriptionAddon: UBDomainSubscriptionAddon?

    // MARK: Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        createAll()
        layoutAll()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Display data

    func bind(chapter: UBDomainProductChapter, product: UBDomainProduct, refScreen: UBDomainReferenceScreen?) {
        self.product = product
        self.refScreen = refScreen

        lbTitle.text = chapter.title.htmlParsed()
        btNotification.isHidden = !UBHelperProductHelper.isPodcastType(product)

        bindTypeAndInfoLabel(product, duration: chapter.duration)
        bindRestrictedSubscriptionState(product)
        bindProductSubscriberState(product)
    }

    func bind(product: UBDomainProduct) {
        self.product = product

        lbTitle.text = product.title.htmlParsed()
        btNotification.isHidden = !UBHelperProductHelper.isPodcastType(product)

        bindTypeAndInfoLabel(product, duration: product.duration)
        bindRestrictedSubscriptionState(product)
        bindProductSubscriberState(product)
    }

    private func bindRestrictedSubscriptionState(_ product: UBDomainProduct) {
        spacingViewBetweenTopButtonAndLbTitle?.update(offset: 12)

        if EnvironmentUtil.hasPremiumAvailableOnlyLabel() {
            let showBtPremium = UBSystemServiceCustomerSystemService.showProductLocked(product)
            btPremiumAvailableOnly.isHidden = !showBtPremium

            if btPremiumAvailableOnly.isHidden {
                spacingViewBetweenTopButtonAndSuperview?.update(offset: 0)
            } else {
                spacingViewBetweenTopButtonAndSuperview?.update(offset: 16)
            }
        } else {
            btPremiumAvailableOnly.isHidden = true
        }
    }

    private func bindProductSubscriberState(_ product: UBDomainProduct) {
        if UBHelperProductHelper.isPodcastType(product) {
            if product.businessModelCustomerSale {
                spacingViewBetweenTopButtonAndLbTitle?.update(offset: 12)

                let canAccessProduct = UBSystemServiceCustomerSystemService.canAccessProduct(product).canAccess

                if canAccessProduct {
                    btExclusiveProductForSubscriber.isHidden = false
                    btExclusiveProduct.isHidden = true
                    btIsNextProduct.isHidden = true
                    btPremiumAvailableOnly.isHidden = true
                } else {
                    btExclusiveProduct.isHidden = false
                    btExclusiveProductForSubscriber.isHidden = true
                    btIsNextProduct.isHidden = true
                    btPremiumAvailableOnly.isHidden = true
                }

                spacingViewBetweenTopButtonAndSuperview?.update(offset: 16)
            }
        }
    }

    private func bindTypeAndInfoLabel(_ product: UBDomainProduct, duration: Int32) {
        let text = NSMutableAttributedString()

        let type = ProductUtil.getCatalogTypeDescription(product: product) ?? ""

        text.append(NSAttributedString(string: type))
        lbTypeAndInfo.accessibilityLabel = type

        if duration > 0, !UBHelperProductHelper.isPodcastType(product) {
            if !type.isEmpty {
                let separator = "  •  "
                text.append(NSAttributedString(
                    string: separator,
                    attributes: [
                        NSAttributedString.Key.foregroundColor: AppData.shared.theme.buttonBackgroundColor(),
                    ]
                ))
            }

            let durationText = "ProductDetailsDurationTitle".localized + ": " + Util.durationTimeFormatted(totalSeconds: Int(duration))
            let durationAccessibility = "ProductDetailsDurationTitle".localized + ": " + Util.durationTimeFormatted(totalSeconds: Int(duration), handleVoiceOver: true)
            text.append(NSAttributedString(string: durationText))

            lbTypeAndInfo.accessibilityLabel = "\(type)\(durationAccessibility)"
        } else if UBHelperProductHelper.isPodcastType(product) {
            if !type.isEmpty {
                let separator = "  •  "
                text.append(NSAttributedString(
                    string: separator,
                    attributes: [
                        NSAttributedString.Key.foregroundColor: AppData.shared.theme.buttonBackgroundColor(),
                    ]
                ))
            }

            let publisherText = product.publisher + " >"
            text.append(NSAttributedString(string: publisherText))

            lbTypeAndInfo.accessibilityLabel = "\(type)\(publisherText)"

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))

            lbTypeAndInfo.isUserInteractionEnabled = true
            lbTypeAndInfo.addGestureRecognizer(tapGesture)
        }

        lbTypeAndInfo.attributedText = text
    }

    // MARK: Build layout

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutIfNeeded()
        applyTopCornerRadius()
    }

    private func applyTopCornerRadius() {
        let radius = ProductDetailsHeaderView.headerViewRadius
        let currentTopCornersLayer = layer.sublayers?.first as? CAShapeLayer

        let topCornersLayer = currentTopCornersLayer ?? CAShapeLayer()
        topCornersLayer.fillColor = UIColor.black.cgColor
        topCornersLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        ).cgPath

        if currentTopCornersLayer == nil {
            layer.insertSublayer(topCornersLayer, at: 0)
        }
    }

    private func createAll() {
        // container view
        addSubview(containerView)
        addSubview(topButtonStackview)

        func configLabel(_ lb: UILabel, _ configBlock: (UILabel) -> Void) {
            containerView.addSubview(lb)
            lb.textAlignment = .left
            lb.isAccessibilityElement = true
            configBlock(lb)
        }

        // premium restriction button
        btPremiumAvailableOnly.image = UIImage(named: "RestrictedAccessLock")?.withRenderingMode(.alwaysTemplate)
        btPremiumAvailableOnly.text = "PremiumSubscriptionRequiredButtonText".localized
        btPremiumAvailableOnly.textAlignment = .left
        btPremiumAvailableOnly.imageInsets = CGPoint(x: 10, y: 0)
        btPremiumAvailableOnly.textInsets = CGPoint(x: 8, y: 0)
        btPremiumAvailableOnly.font = UIFont(name: SettingsThemeFont.bold.name, size: UIDevice.current.iPad ? 16 : 12)
        btPremiumAvailableOnly.imageSize = CGSize(width: 10, height: 13)
        btPremiumAvailableOnly.tintColor = .white
        btPremiumAvailableOnly.backgroundColor = UIColor(hexString: "4F4F4F")
        btPremiumAvailableOnly.layer.cornerRadius = 5
        btPremiumAvailableOnly.clipsToBounds = true
        btPremiumAvailableOnly.isHidden = true
        btPremiumAvailableOnly.addTarget(self, action: #selector(onPremiumAvailableOnlyButton), for: .touchUpInside)

        // is next product button
        btIsNextProduct.image = UIImage(named: "IsNextProduct")?.withRenderingMode(.alwaysTemplate)
        btIsNextProduct.text = "IsNextProductButtonText".localized
        btIsNextProduct.textAlignment = .left
        btIsNextProduct.imageInsets = CGPoint(x: 10, y: 0)
        btIsNextProduct.textInsets = CGPoint(x: 8, y: 0)
        btIsNextProduct.font = UIFont(name: SettingsThemeFont.bold.name, size: UIDevice.current.iPad ? 16 : 12)
        btIsNextProduct.imageSize = CGSize(width: 13, height: 13)
        btIsNextProduct.tintColor = .white
        btIsNextProduct.backgroundColor = UIColor(hexString: "4F4F4F")
        btIsNextProduct.layer.cornerRadius = 5
        btIsNextProduct.clipsToBounds = true
        btIsNextProduct.isHidden = true

        // exclusive product button
        btExclusiveProduct.image = UIImage(named: "RestrictedAccessLock")?.withRenderingMode(.alwaysTemplate)
        btExclusiveProduct.text = "IsProductExclusive".localized
        btExclusiveProduct.textAlignment = .left
        btExclusiveProduct.imageInsets = CGPoint(x: 10, y: 0)
        btExclusiveProduct.textInsets = CGPoint(x: 8, y: 0)
        btExclusiveProduct.font = UIFont(name: SettingsThemeFont.bold.name, size: UIDevice.current.iPad ? 16 : 12)
        btExclusiveProduct.imageSize = CGSize(width: 10, height: 13)
        btExclusiveProduct.tintColor = .white
        btExclusiveProduct.backgroundColor = UIColor(hexString: "4F4F4F")
        btExclusiveProduct.layer.cornerRadius = 5
        btExclusiveProduct.clipsToBounds = true
        btExclusiveProduct.isHidden = true

        // exclusive product button
        btExclusiveProductForSubscriber.image = UIImage(named: "HasProductSubscription")?.withRenderingMode(.alwaysOriginal)
        btExclusiveProductForSubscriber.text = "IsProductExclusiveForSubscriber".localized
        btExclusiveProductForSubscriber.textAlignment = .left
        btExclusiveProductForSubscriber.imageInsets = CGPoint(x: 10, y: 0)
        btExclusiveProductForSubscriber.textInsets = CGPoint(x: 8, y: 0)
        btExclusiveProductForSubscriber.font = UIFont(name: SettingsThemeFont.bold.name, size: UIDevice.current.iPad ? 16 : 12)
        btExclusiveProductForSubscriber.imageSize = CGSize(width: 12, height: 9)
        btExclusiveProductForSubscriber.tintColor = .white
        btExclusiveProductForSubscriber.backgroundColor = UIColor(hexString: "4F4F4F")
        btExclusiveProductForSubscriber.layer.cornerRadius = 5
        btExclusiveProductForSubscriber.clipsToBounds = true
        btExclusiveProductForSubscriber.isHidden = true

        // notifications button
        containerView.addSubview(btNotification)
        notificationsOn = false
        btNotification.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        btNotification.addTarget(self, action: #selector(onBtNotificationTouchUpInside), for: .touchUpInside)

        // title
        configLabel(lbTitle) {
            $0.font = UIBaseSettings.Font.productDetailTitle
            $0.textColor = .white
            $0.numberOfLines = 3
            $0.accessibilityTraits = .header
        }

        // type and duration
        configLabel(lbTypeAndInfo) {
            $0.font = UIBaseSettings.Font.productDetailInfo
            $0.textColor = UIColor(hexString: "BDBDBD")
            $0.numberOfLines = 1
        }
    }

    private func layoutAll() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview()
        }

        topButtonStackview.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)

            spacingViewBetweenTopButtonAndSuperview = $0.top.equalToSuperview().constraint
        }

        btPremiumAvailableOnly.snp.makeConstraints {
            $0.height.equalTo(UIDevice.current.iPad ? 32 : 26)
        }

        btIsNextProduct.snp.makeConstraints {
            $0.height.equalTo(UIDevice.current.iPad ? 32 : 26)
        }

        btExclusiveProduct.snp.makeConstraints {
            $0.height.equalTo(UIDevice.current.iPad ? 32 : 26)
        }

        btExclusiveProductForSubscriber.snp.makeConstraints {
            $0.height.equalTo(UIDevice.current.iPad ? 32 : 26)
        }

        lbTitle.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)

            spacingViewBetweenTopButtonAndLbTitle = $0.top.equalTo(topButtonStackview.snp.bottom).constraint
        }

        btNotification.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(lbTitle.snp.trailing)
            $0.width.height.equalTo(24)
        }

        lbTypeAndInfo.snp.makeConstraints {
            $0.top.equalTo(lbTitle.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: User actions

    @objc private func onPremiumAvailableOnlyButton() {
        UIUtil.showAlertMessage(title: "PremiumSubscriptionRequiredAlertTitle".localized, message: "PremiumSubscriptionRequiredAlertMessage".localized)
    }

    @objc private func onPurchaseChangeTapGesture(tapGestureRecognizer _: UITapGestureRecognizer) {
        if UBHelperEnvironmentHelper.isUreader() {
            onPurchaseClickFromUreader()
        } else if UBHelperEnvironmentHelper.isUbookGo() {
            if isNextProduct {
                onPurchaseClickFromUbookGoWhenIsNextProduct()
            } else {
                onPurchaseClickFromUbookGo()
            }
        }
    }

    @objc private func onBtNotificationTouchUpInside() {
        notificationsOn = !notificationsOn
        // TODO: UBKMI-1730 adicionar comportamento de ativar/desativar a notificacao. ao ativar a notificacao se o usuario nao seguir o podcasr ele segue automaticamente
    }

    @objc private func labelTapped() {
        // go to publisher
        // TODO: UBKMI-1730 adicionar a navegacao pra pagina da editora
    }

    private func onPurchaseClickFromUreader() {
        UIUtil.showAlertLoading()

        DispatchQueue.global(qos: .background).async { [weak self] in
            let data = UBSystemServiceCustomerSystemService.getAutoLoginToken(UBHelperCustomerHelper.getToken())
            let autoLoginToken = data.autoLoginToken

            DispatchQueue.main.async { [weak self] in
                UIUtil.hideAlertLoading()

                if let topViewController = UIApplication.topViewController() {
                    if autoLoginToken.isEmpty {
                        UIUtil.showAlertError(fromViewController: topViewController, title: "DialogTitle".localized, message: ResponseUtil.getResponseMessage(response: data.response), onClose: nil)
                    } else {
                        if let marketplace = UBCoreApplicationCore.shared()?.getMarketplace(), let product = self?.product {
                            let url = String(format: "%@/autologin/index/id/%@/route/product/cid/%@", marketplace.productionBaseUrl, autoLoginToken, String(product.catalogId))
                            let refAction = UBDomainReferenceAction(refAction: "product", refActionInfo: product.title)

                            PopupWebViewController.showPopupGet(parent: topViewController, url: url, refAction: refAction, refScreen: self?.refScreen)
                        }
                    }
                }
            }
        }
    }

    private func onPurchaseClickFromUbookGo() {
        guard let product = subscriptionAddon else { return }
        guard let topViewController = UIApplication.topViewController() else { return }

        UIUtil.openDigitalLicenseExchangeViewController(source: topViewController.navigationController, subscriptionAddon: product)
    }

    private func onPurchaseClickFromUbookGoWhenIsNextProduct() {
        guard let topViewController = UIApplication.topViewController() else { return }

        UIUtil.goToMainViewController(vc: topViewController)
    }
}
