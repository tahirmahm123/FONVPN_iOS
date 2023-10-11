//
//  FavouritesLocationView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 19/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//


import SwiftUI

struct FavouritesLocationsWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    @Binding var favouritesShown: Bool
    var onServerSelection: (() -> ())?
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        let tableView = UITableView(frame: viewController.view.bounds, style: .insetGrouped)
        
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.backgroundColor = UIColor.systemBackground
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.bounces = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.register(UINib(nibName: String(describing: ServerDetailsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ServerDetailsCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(tableView)
        context.coordinator.tableView = tableView
        context.coordinator.serverUpdater = loadFavouritesFromCoreData
        viewController.navigationItem.title = "Favourites"
        let favouritesButton = UIButton(type: .system)
        favouritesButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        favouritesButton.addAction({
            $favouritesShown.wrappedValue = false
        }, for: .touchUpInside)
        context.coordinator.updateBackgroundView()
        let leftButtonItem = UIBarButtonItem(customView: favouritesButton)
        viewController.navigationItem.leftBarButtonItem = leftButtonItem
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = false
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let serverList = loadFavouritesFromCoreData()
        context.coordinator.serversList = serverList
        context.coordinator.tableView?.reloadData()
        context.coordinator.updateBackgroundView()
    }

    func makeCoordinator() -> Coordinator {
        let cordinator = Coordinator(onServerSelection: self.onServerSelection!)
        cordinator.serversList = loadFavouritesFromCoreData()
        return cordinator
    }
    
    
    func loadFavouritesFromCoreData() -> [Servers]? {
//        if let list: [Int] = [] {//self.getFavouriteListFromCoreData() {
//            var favrtList : [Servers] = []
//            for i in 0..<list.count {
//                if let server = ApiManager.shared.serversList?.first(where: {$0.id == Int(list[i].id ?? "0")}) {
//                    favrtList.append(server)
//                }
//            }
////            self.hideHUD()
//            return favrtList
//        }
        return nil
    }
//    func getFavouriteListFromCoreData() -> [FavouritesModel]? {
//        if let favouriteList = FavouritesModel.getAllobjects() as? [FavouritesModel] {
//            return favouriteList
//        }
//        return nil
//    }
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource, FavouritesSelected {
        var onServerSelection: () -> ()
        var searchFocused: Bool = false
        var selectedSection: Int?
        func selectedProtocol() -> ProtocolType {
            return userDefaults.object(forKey: SelectedProtocol) as? ProtocolType ?? .openvpn
        }
        var items: [Servers]?
        var filteredItems: [Servers]?
        var serversList : [Servers]?
        weak var tableView: UITableView?
        var navigationBar: UINavigationBar?
        var serverUpdater: (() -> [Servers]?)?
        
        init(onServerSelection: @escaping () -> Void) {
            self.onServerSelection = onServerSelection
        }
        
            //number of countries
        func numberOfSections(in tableView: UITableView) -> Int {
            if let countOfCountries = self.serversList?.count {
                return countOfCountries
            }
            return  0
        }
            // number of servers + 1
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
            // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 10
        }
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 64
            } else {
                return 48
            }
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return ""
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ServerDetailsCell.self)) as! ServerDetailsCell
            cell.contentView.layer.cornerRadius = 10
            cell.delegate = self
            cell.favouriteButton.isSelected = true
            cell.tag = indexPath.section
            let serverDetails = self.serversList![indexPath.section]
                //self.searchResultServers[indexPath.section]
            cell.serverCountryFlag.image = UIImage.init(named: serverDetails.country_code.lowercased())
            cell.serverCountryFlag.layer.cornerRadius = cell.serverCountryFlag.frame.height / 2
            if let serverPing = serverDetails.pingMs {
                if  serverPing > 0 && serverPing < 60 {
                    cell.serverSignalStrength.image = UIImage.init(named: "Excelent")
                } else  if  serverPing >= 60 && serverPing < 120 {
                    cell.serverSignalStrength.image = UIImage.init(named: "Medium")
                }  else  if  serverPing >= 120 && serverPing < 200 {
                    cell.serverSignalStrength.image = UIImage.init(named: "Poor")
                } else {
                    cell.serverSignalStrength.image = UIImage.init(named: "Poor")
                }
            } else {
                cell.serverSignalStrength.image = UIImage.init(named: "Poor")
            }
            cell.serverId = serverDetails.id
            cell.serverCountryName.text = serverDetails.country
            cell.serverName.text = serverDetails.name
//            if FavouriteManager.shared.isFavourite(serverName:  cell.serverName.text ?? "", id: String(cell.serverId), serverId:  cell.serverId ) {
//                cell.favouriteButton.isSelected = true
//            } else {
//                cell.favouriteButton.isSelected = false
//            }
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            userDefaults.set(false, forKey: SelectRandomServer)
            userDefaults.set(false, forKey: AutoSelectFastServer)
            if tableView.cellForRow(at: indexPath) is ServerRowCell{
                let serverDetails = self.serversList![indexPath.section]
                userDefaults.set(serverDetails.id, forKey: LastSelectedServer)
                BackButtonTapped = false
            }
            onServerSelection()
            tableView.deselectRow(at: indexPath, animated: false)
        }

        func favouritesTapped(serverName: String, id: String, serverId: Int) {
            let vcInfo:[String: String] = ["VcName": "AllLocationVC"]
//            FavouriteManager.shared.manageFavouriteInCoreData(serverName: serverName , id: id, serverId: serverId)
            NotificationCenter.default.post(name: Notification.Name.FavouritesStatusChanged, object: nil, userInfo: vcInfo)
            self.updateTableView()
        }
        
        func updateTableView() {
            self.serversList = serverUpdater!()
            self.tableView?.reloadData()
            self.updateBackgroundView()
        }
        
        
        func updateBackgroundView() {
            if serversList!.isEmpty {
                let vc = UIHostingController(rootView: FavouritesBackground())
                tableView!.backgroundView = vc.view
                tableView!.separatorStyle = .none
            } else {
                tableView!.backgroundView = nil
                tableView!.separatorStyle = .singleLine
            }
        }
    }
    
}
