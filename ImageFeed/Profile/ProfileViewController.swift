import Kingfisher
import UIKit

@MainActor
protocol ProfileViewControllerProtocol: AnyObject {
    func showProfileDetails(
        personName: String,
        username: String,
        profileDescription: String
    )
    func showAvatar(url: URL)
    func showLogoutAlert()
}

@MainActor
final class ProfileViewController: UIViewController,
    ProfileViewControllerProtocol
{
    private let userPicImageView = UIImageView()
    private let personNameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let profileDescriptionLabel = UILabel()
    private let exitButton = UIButton()

    var presenter: ProfilePresenterProtocol?
    private var animationLayers = [CALayer]()
    private var infoDidLoaded = false
    private var didSetupSkeleton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
        setConstraints()
        if presenter == nil {
            presenter = ProfilePresenter()
        }
        presenter?.view = self
        presenter?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userPicImageView.layer.cornerRadius = userPicImageView.bounds.height / 2

        if !infoDidLoaded && !didSetupSkeleton {
            addGradientLayer(to: [userPicImageView, personNameLabel, usernameLabel, profileDescriptionLabel])
            didSetupSkeleton = true
        }
    }
    
    private func setupViewElements() {
        view.backgroundColor = .ypBlackIOS

        userPicImageView.translatesAutoresizingMaskIntoConstraints = false
        userPicImageView.image = UIImage(named: "no_profile_pic")
        userPicImageView.clipsToBounds = true
        userPicImageView.isHidden = true

        personNameLabel.text = ""
        personNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        personNameLabel.textColor = UIColor(named: "YP White (iOS)")
        personNameLabel.translatesAutoresizingMaskIntoConstraints = false
        personNameLabel.numberOfLines = 0
        personNameLabel.lineBreakMode = .byWordWrapping

        usernameLabel.text = ""
        usernameLabel.font = UIFont.systemFont(ofSize: 13)
        usernameLabel.textColor = UIColor(named: "YP Gray (iOS)")
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.numberOfLines = 1
        usernameLabel.lineBreakMode = .byTruncatingTail

        profileDescriptionLabel.text = ""
        profileDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
        profileDescriptionLabel.textColor = UIColor(named: "YP White (iOS)")
        profileDescriptionLabel.translatesAutoresizingMaskIntoConstraints =
            false
        profileDescriptionLabel.numberOfLines = 0
        profileDescriptionLabel.lineBreakMode = .byWordWrapping
        profileDescriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        exitButton.setImage(UIImage(named: "Exit"), for: .normal)
        exitButton.addAction(
            UIAction { [weak self] _ in
                self?.presenter?.didTapLogout()
            },
            for: .touchUpInside
        )
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.isHidden = true
        exitButton.accessibilityIdentifier = "exitButton"
        view.addSubview(userPicImageView)
        view.addSubview(personNameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(profileDescriptionLabel)
        view.addSubview(exitButton)

    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            userPicImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
            userPicImageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            userPicImageView.widthAnchor.constraint(equalToConstant: 70),
            userPicImageView.heightAnchor.constraint(equalToConstant: 70),

            personNameLabel.topAnchor.constraint(
                equalTo: userPicImageView.bottomAnchor,
                constant: 8
            ),
            personNameLabel.leadingAnchor.constraint(
                equalTo: userPicImageView.leadingAnchor
            ),
            personNameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: exitButton.leadingAnchor,
                constant: -16
            ),

            usernameLabel.topAnchor.constraint(
                equalTo: personNameLabel.bottomAnchor,
                constant: 8
            ),
            usernameLabel.leadingAnchor.constraint(
                equalTo: userPicImageView.leadingAnchor
            ),
            usernameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: exitButton.leadingAnchor,
                constant: -16
            ),

            profileDescriptionLabel.topAnchor.constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: 8
            ),
            profileDescriptionLabel.leadingAnchor.constraint(
                equalTo: usernameLabel.leadingAnchor
            ),
            profileDescriptionLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            profileDescriptionLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),

            exitButton.centerYAnchor.constraint(
                equalTo: userPicImageView.centerYAnchor
            ),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
        ])
    }

    func showProfileDetails(
        personName: String,
        username: String,
        profileDescription: String

    ) {
        personNameLabel.text = personName
        usernameLabel.text = username
        profileDescriptionLabel.text = profileDescription
        exitButton.isHidden = false
        userPicImageView.isHidden = false
        infoDidLoaded = true
        removeGradients()
        didSetupSkeleton = false
    }

    func showAvatar(url: URL) {
        let placeholderImage = UIImage(named: "no_profile_pic")
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        userPicImageView.kf.indicatorType = .activity
        userPicImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh,
            ]
        ) {
            result in
            switch result {
            case .success(let value):
                print(value.image)
                print(value.cacheType)
                print(value.source)
            case .failure(let error):
                print(error)
            }
        }
    }

    func showLogoutAlert() {

        let yesAction = UIAlertAction(title: "Да", style: .default) {
            [weak self] _ in
            self?.presenter?.userConfirmedLogout()
        }
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
            return
        }
        AlertService.shared.showAlert(
            withTitle: "Пока, пока!",
            andMessage: "Уверены, что хотите выйти?",
            withActions: [
                yesAction,
                noAction,

            ],
            withAccessibilityIdentifier: "confirmLogoutAlert",
            on: self
        )

    }
    
    func addGradientLayer(to views: [UIView]) {
        guard animationLayers.isEmpty else { return }

        for view in views {
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.locations = [0, 0.1, 0.3]
            gradient.colors = [
                UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
                UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
                UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor,
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            gradient.cornerRadius = view.layer.cornerRadius > 0 ? view.layer.cornerRadius : 9
            gradient.masksToBounds = true
            view.layer.addSublayer(gradient)
            animationLayers.append(gradient)

            let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
            gradientChangeAnimation.duration = 1
            gradientChangeAnimation.repeatCount = .infinity
            gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
            gradientChangeAnimation.toValue = [0, 0.8, 1]
            gradientChangeAnimation.isRemovedOnCompletion = false
            gradient.add(gradientChangeAnimation, forKey: "locationsChange")
        }
    }
    
    private func removeGradients() {
        animationLayers.forEach { layer in
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        animationLayers.removeAll()
    }
}
