//
//  ViewController.swift
//  CustomFontsTest
//
//  Created by Eduard Kanevskii on 05.09.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let testField = UITextField()
    private let imagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    /// расстояние по бокам от collectionView
    private let inset: CGFloat = 16
    /// количество ячеек на ширину экрана (на стартовых макетах по 2)
    private let cellCountPerWidth: CGFloat = 2
    private let cellPadding: CGFloat = 12
    
    private var images: [String] {
        var i: [String] = []
        for index in 0...19 {
            i.append("\(index)")
        }
        return i
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = isDarkTheme ? .black : .white
        testField.placeholder = "Type text"

        view.addSubview(testField)
        testField.textColor = isDarkTheme ? .white : .black
        testField.tintColor = isDarkTheme ? .white : .black
//        testField.backgroundColor = .blue
        testField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        setupImagesCollectionView()
    }
    
    private func setupImagesCollectionView() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.backgroundColor  = .clear
        imagesCollectionView.showsVerticalScrollIndicator = false
        imagesCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
//        imagesCollectionView.register(RestaurantCompilationHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RestaurantCompilationHeader.identifier)
        imagesCollectionView.register(ImagesCompilationCell.self, forCellWithReuseIdentifier: ImagesCompilationCell.identifier)
//        imagesCollectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: RestaurantCell.identifier)
        
        if let flowLayout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
        
        view.addSubview(imagesCollectionView)
        imagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(testField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func buttonTapped() {
        
//        ThemeService.shared.backgroundColor = .blue
        // think about colors and images
        print(images.count)
        UserDefaults(suiteName: "group.kanevsky.testkeyboard")?.setValue("ThemeService.shared.backgroundColor", forKey: "text1")
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCompilationCell.identifier, for: indexPath) as? ImagesCompilationCell else { return UICollectionViewCell() }
        
        cell.update(with: images[indexPath.row])
        
        return cell
    }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let restaurantCellHeight: CGFloat = 120
        let restaurantCellWidth: CGFloat = (view.bounds.width / 2) - (inset * 2)
        return CGSize(width: restaurantCellWidth, height: restaurantCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}


final class ImagesCompilationCell: UICollectionViewCell
{
    private let imageView = UIImageView()
    private let gradientView = UIView()
    private let restaurantName = UILabel()
    private let gradientColor = UIColor(hex: "#000000")
        
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupCell()
    }
    
    func update(with imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
    
    private func setupCell()
    {
        layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        addSubviews([imageView, gradientView])
        gradientView.addSubview(restaurantName)
        setupImageView()
        setupGradientView()
        setupRestaurantName()
    }
    
    private func setupImageView() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupGradientView() {
        gradientView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(bounds.height / 2.5)
        }
        
        gradientView.layer.cornerRadius = 10
//        gradientView.startColor = gradientColor.withAlphaComponent(0)
//        gradientView.endColor = gradientColor.withAlphaComponent(0.6)
    }
    
    private func setupRestaurantName() {
        restaurantName.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
        }
        
        restaurantName.textAlignment = .center
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor
{
    convenience init?(hex: String?)
    {
        guard let hex = hex else {
            return nil
        }
        
        self.init(hex: hex)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0)
    {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") { cString.removeFirst() }

        if (cString.count) != 6 {
            self.init(hex: "ffffff")
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    public func hexString(_ includeAlpha: Bool = true) -> String
    {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}

extension UICollectionReusableView {
    static var identifier: String {
        "\(self)"
    }
}

extension UIView
{
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { self.addSubview($0) }
    }
    
    func roundOnlyTopCorners(radius: CGFloat = 20) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}

extension UIStackView {
    func addArranged(subviews:[UIView]) {
        subviews.forEach { self.addArrangedSubview($0) }
    }
}

let userTheme = UIScreen.main.traitCollection.userInterfaceStyle

var isDarkTheme: Bool {
    userTheme == .dark
}
