//
//  LocationTableView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 14/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
import ExpyTableView

struct LocationsWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    var isQuickSettings = false
//    @Binding var searchOverlayVisible: Bool
    @EnvironmentObject var router: AppRouter
    var onServerSelection: (() -> ())?
    func serverData() -> [ServerByCountry]? {
       return ApiManager.shared.groupedServersByCountry
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        let tableView = ExpyTableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.backgroundColor = UIColor.systemBackground
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.bounces = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        context.coordinator.tableView = tableView
        tableView.register(UINib(nibName: String(describing: ServerDetailsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ServerDetailsCell.self))
        tableView.register(UINib(nibName: String(describing: ServerHeaderCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ServerHeaderCell.self))
        tableView.register(UINib(nibName: String(describing: RandomFastestRowCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RandomFastestRowCell.self))
        tableView.register(UINib(nibName: String(describing: ServerRowCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ServerRowCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = context.coordinator
        searchController.delegate = context.coordinator
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        viewController.navigationItem.searchController = searchController
        viewController.definesPresentationContext = true
        viewController.view.addSubview(tableView)
//        
//        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.hidesSearchBarWhenScrolling = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        context.coordinator.availableServersListGrouped = serverData()
//        context.coordinator.tableView?.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        let cordinator = Coordinator(onServerSelection: self.onServerSelection!, isQuickSettings: self.isQuickSettings)
        cordinator.availableServersListGrouped = serverData()
        return cordinator
    }
    

    
    class Coordinator: NSObject, ExpyTableViewDelegate, ExpyTableViewDataSource, FavouritesSelected, ServerOptionSelected, UISearchControllerDelegate, UISearchResultsUpdating {
        var isQuickSettings: Bool
        var onServerSelection: () -> ()
        var searchFocused: Bool = false
        var selectedSection: Int?
        func  selectedProtocol () -> ProtocolType {
            return userDefaults.object(forKey: SelectedProtocol) as? ProtocolType ?? .openvpn
        }
//        var updateNavigatonBarVisibility: ((Bool) -> Void)?
        var items: [Servers]?
        var filteredItems: [Servers]?
        var availableServersListGrouped : [ServerByCountry]?
        weak var tableView: ExpyTableView?
        var navigationBar: UINavigationBar?
        
        
        init(onServerSelection: @escaping () -> Void, isQuickSettings: Bool) {
            self.onServerSelection = onServerSelection
            self.isQuickSettings = isQuickSettings
        }
        
        
        func randomServerPressed(){
                userDefaults.set(  ApiManager.shared.getRandomServer()?.id, forKey: LastSelectedServer)
            BackButtonTapped = false
            userDefaults.set(false, forKey: AutoSelectFastServer)
            userDefaults.set(true, forKey: SelectRandomServer)
            
            onServerSelection()
        }
        func fastestServerPressed(){
            userDefaults.set(  ApiManager.shared.getFastestServer()?.id, forKey: LastSelectedServer)
            if userDefaults.bool(forKey: AutoSelectFastServer){
                BackButtonTapped = true
            } else {
                userDefaults.set(true, forKey: AutoSelectFastServer)
                BackButtonTapped = false
            }
            userDefaults.set(false, forKey: SelectRandomServer)

            onServerSelection()
        }
            //number of countries
        func numberOfSections(in tableView: UITableView) -> Int {
            if searchFocused {
                return self.filteredItems?.count ?? 0
            }
            if let countOfCountries = self.availableServersListGrouped?.count {
                if isQuickSettings {
                    return countOfCountries
                }else{
                    return countOfCountries + 1
                }
            }
            return  0
        }
            // number of servers + 1
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if searchFocused {
                return 1
            } else {
                if section == 0 && !isQuickSettings {
                    return 2
                } else {
                    let currentSection: Int
                    if isQuickSettings {
                        currentSection = section
                    } else {
                        currentSection = section - 1
                    }
                    if let countOfServers = self.availableServersListGrouped![currentSection].servers?.count  {
                        return countOfServers + 1
                    } else {
                        return 0
                    }
                }
            }
        }
            // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if searchFocused {
                return 10
            } else {
                if section == 0 && !isQuickSettings{
                    return 10
                } else if section == 1 {
                    return 30
                } else {
                    return 10
                }
            }
        }
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if searchFocused {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    return 84
                } else {
                    return 64
                }
            } else {
                if indexPath.section == 0 && !isQuickSettings{
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        return 84
                    } else {
                        return 54
                    }
                } else {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        if indexPath.row == 0 {
                            return 84
                        } else {
                            return 64
                        }
                    } else {
                        if indexPath.row == 0 {
                            return 54
                        } else {
                            return 48
                        }
                    }
                }
            }
        }
            //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            //        let view = UIView()
            //        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: section == 1 ? 18 : 10)
            //        view.backgroundColor = UIColor.clear
            //        if section == 1 {
            //            let label = UILabel()
            //            label.text = "All Servers"
            //            label.textColor = .systemGray4
            //            view.addSubview(label)
            //        }
            //        return view
            //    }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if !isQuickSettings {
                return section == 1 && !searchFocused ? "All Servers" : ""
            }else {
                return ""
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if searchFocused {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ServerDetailsCell.self)) as! ServerDetailsCell
                cell.contentView.layer.cornerRadius = 10
                cell.delegate = self
                cell.favouriteButton.isSelected = true
                cell.tag = indexPath.section
                let serverDetails = self.filteredItems![indexPath.section]
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
//                if FavouriteManager.shared.isFavourite(serverName:  cell.serverName.text ?? "", id: String(cell.serverId), serverId:  cell.serverId ) {
//                    cell.favouriteButton.isSelected = true
//                } else {
//                    cell.favouriteButton.isSelected = false
//                }
                return cell
            } else {
                if indexPath.section == 0 && !isQuickSettings{
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RandomFastestRowCell.self)) as! RandomFastestRowCell
                    if indexPath.row == 0 {
                        cell.imageIcon.image = UIImage(named: "RandomServerIcon")
                        cell.titleLabel.text = "Random Location"
                    }else{
                        cell.imageIcon.image = UIImage(named: "FastServerIcon")
                        cell.titleLabel.text = "Fast Location"
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ServerRowCell.self)) as! ServerRowCell
                    cell.layer.cornerRadius = 0
                    cell.delegate = self
                    let currentSection: Int
                    if isQuickSettings {
                        currentSection = indexPath.section
                    } else {
                        currentSection = indexPath.section - 1
                    }
                    if let countOfServers = self.availableServersListGrouped![currentSection].servers?.count  {
                        if indexPath.row == countOfServers { // corner radius to last index of locations
                            cell.layer.cornerRadius = 10
                            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                        }
                    }
                    let serverDetails: ServerByCountry = self.availableServersListGrouped![currentSection]
                    let server = serverDetails.servers![indexPath.row - 1]
                    if server.id == userDefaults.integer(forKey: LastSelectedServer){
                        cell.selectedServerButton.isSelected = true
                    } else {
                        cell.selectedServerButton.isSelected = false
                    }
                    cell.tag = indexPath.row
                    cell.serverCity.text = server.name
                    cell.serverId = server.id
                    
                    if let serverPing = server.pingMs {
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
//                    if FavouriteManager.shared.isFavourite(serverName:  cell.serverCity.text ?? "", id: String(cell.serverId), serverId:  cell.serverId ) {
//                        cell.favouriteButton.isSelected = true
//                    } else {
//                        cell.favouriteButton.isSelected = false
//                    }
                    return cell
                }
            }
        
        }
            // Server Countries
        func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ServerHeaderCell.self)) as! ServerHeaderCell
                //        if tableView == searchTableView{
                //        } else {
            cell.delegate = self
            cell.tag = section
            cell.layer.cornerRadius = 10
                //                cell.headerBtn.isHidden = true
            if section == selectedSection {
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
            let currentSection: Int
            if isQuickSettings {
                currentSection = section
            } else {
                currentSection = section - 1
            }
            if let groupedLeader = self.availableServersListGrouped?[currentSection] {
                if let serverGroupTitle = groupedLeader.country {
                    cell.serverCountry.text = "\(serverGroupTitle)"
                    if groupedLeader.servers?.count == 1 {
                        cell.locationCountLbl.text = "\(String(describing: groupedLeader.servers!.count))  Location"
                    } else {
                        cell.locationCountLbl.text = "\(String(describing: groupedLeader.servers!.count))  Locations"
                    }
                    let flagName = groupedLeader.flag?.lowercased()
                    cell.serverCountryFlag.image = UIImage.init(named: flagName ?? "")
                    cell.serverCountryFlag.layer.cornerRadius = cell.serverCountryFlag.frame.height / 2
                    cell.serverCountryFlag.clipsToBounds = true
                }
            }
                //        }
            return cell
        }
        
        func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
            if isQuickSettings {
                return ExpyTableViewDefaultValues.expandableStatus
            } else {
                if section != 0 && !searchFocused {
                    return ExpyTableViewDefaultValues.expandableStatus
                }
                return false
            }
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if indexPath.section == 0 && !searchFocused && !isQuickSettings{
                if indexPath.row == 0 {
                    self.randomServerPressed()
                } else {
                    self.fastestServerPressed()
                }
            }else{
                if !isQuickSettings {
                    userDefaults.set(false, forKey: SelectRandomServer)
                    userDefaults.set(false, forKey: AutoSelectFastServer)
                }
                if tableView.cellForRow(at: indexPath) is ServerRowCell || tableView.cellForRow(at: indexPath) is ServerDetailsCell{
                    
                    let server: Servers
                    if searchFocused {
                        server = filteredItems![indexPath.row]
                    } else {
                        let currentSection: Int
                        if isQuickSettings {
                            currentSection = indexPath.section
                        } else {
                            currentSection = indexPath.section - 1
                        }
                        let serverDetails = self.availableServersListGrouped![currentSection]
                        server = serverDetails.servers![indexPath.row - 1]
                    }
                    if isQuickSettings {
                        userDefaults.set(server.id, forKey: QuickSettingsServer)
                    }else{
                        userDefaults.set(server.id, forKey: LastSelectedServer)
                    }
                    onServerSelection()
                    BackButtonTapped = false
                }
            }
            tableView.deselectRow(at: indexPath, animated: false)
        }
        func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
                //        if tableView == serversList{
            if state == .willExpand{
                let indexPath = IndexPath(item: 0, section: section)
                if let cell = tableView.cellForRow(at: indexPath) as? ServerHeaderCell
                {
                  cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                  UIView.transition(with: cell.expandableImageView,
                                    duration: 2,
                                    options: .curveEaseIn,
                                    animations: {
                      cell.expandableImageView.image = UIImage.init(named: "arrow-up")
                  },
                                    completion: nil)
                }
            } else if state == .willCollapse{
                let indexPath = IndexPath(item: 0, section: section)
                if let cell = tableView.cellForRow(at: indexPath) as? ServerHeaderCell{
                    UIView.transition(with:  cell.expandableImageView,
                                      duration: 2,
                                      options: .curveEaseOut,
                                      animations: {
                        cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner , .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                        cell.expandableImageView.image = UIImage.init(named: "arrow-down") },
                                      completion: nil)
                }
            } else if state == .didExpand{
                if let selectedSection = selectedSection{
                    if selectedSection != section {
                        self.tableView!.collapse(selectedSection)
                    }
                }
                selectedSection = section
            }
        }
        
        func favouritesTapped(serverName: String, id: String, serverId: Int) {
            let vcInfo:[String: String] = ["VcName": "AllLocationVC"]
//            FavouriteManager.shared.manageFavouriteInCoreData(serverName: serverName , id: id, serverId: serverId)
            NotificationCenter.default.post(name: Notification.Name.FavouritesStatusChanged, object: nil, userInfo: vcInfo)
        }
        func buttonTapped(id: Int) {
            if id == 0 {
                self.randomServerPressed()
            } else {
                self.fastestServerPressed()
            }
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
            searchFocused = true
//                // Access the navigation bar
//            if let navigationBar = navigationBar {
//                let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = .clear
//                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//                navigationBar.standardAppearance = appearance
//                navigationBar.scrollEdgeAppearance = appearance
//            }
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filteredItems = searchText.isEmpty ? items : items!.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            tableView?.reloadData()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchFocused = false
            searchBar.text = nil
            filteredItems = items
            tableView?.reloadData()
            searchBar.resignFirstResponder()
                // Reset the navigation bar appearance
//            if let navigationBar = navigationBar {
//                navigationBar.standardAppearance = nil
//                navigationBar.scrollEdgeAppearance = nil
//            }
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            let searchText = searchController.searchBar.text!
            filteredItems = searchText.isEmpty ? items : items!.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.country.localizedCaseInsensitiveContains(searchText) || $0.name.localizedCaseInsensitiveContains(searchText) }
            tableView?.reloadData()
            print("Update Search Results")
        }
        func willPresentSearchController(_ searchController: UISearchController) {
            searchFocused = true
            items = ApiManager.shared.serversList
            filteredItems = items
            searchController.searchBar.text = nil
            tableView?.reloadData()
        }
        func willDismissSearchController(_ searchController: UISearchController) {
            searchFocused = false
            searchController.searchBar.text = nil
            tableView?.reloadData()
        }
    }
    
}
