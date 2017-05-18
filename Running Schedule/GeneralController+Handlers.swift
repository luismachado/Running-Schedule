//
//  GeneralController+Fetching.swift
//  RunPortugal
//
//  Created by Luís Machado on 31/03/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

extension GeneralController {
    
    func handleSearch(searchTerm: String?) {
        
        if let searchTerm = searchTerm {
            
            if searchTerm == "" {
                racesToDisplay = filteredRaces
            } else {
                racesToDisplay = [Race]()
                
                for race in filteredRaces {
                    
                    if let raceName = race.name {
                        if raceName.contains(searchTerm) {
                            racesToDisplay.append(race)
                            continue
                        }
                    }
                    
                    if let distances = race.distances {
                        if distances.contains(searchTerm) {
                            racesToDisplay.append(race)
                            continue
                        }
                    }
                    
                    if let locations = race.locationName {
                        if locations.contains(searchTerm) {
                            racesToDisplay.append(race)
                            continue
                        }
                    }
                }
            }
            
            if racesToDisplay.count == 0 {
                noResultsLabel.isHidden = false
                noResultsLabel.text = noRaceFound
            } else {
                noResultsLabel.isHidden = true
            }
            
            collectionView?.reloadData()
        }
    }
    
    func handleToggleSearch(newFilterApplied: Bool = false) {
        
        if let collectionView = collectionView {
            
            var insetValue: CGFloat = 50
            if searchOpen {
                insetValue = -50
                dismissKeyboard()
                if !newFilterApplied {
                    
                    if racesToDisplay != filteredRaces {
                        racesToDisplay = filteredRaces
                        collectionView.reloadData()
                    }
                    
                    if racesToDisplay.count == 0 {
                        noResultsLabel.isHidden = false
                        noResultsLabel.text = noRaceFound
                    } else {
                        noResultsLabel.isHidden = true
                    }
                }
            }
            
            searchOpen = !searchOpen
            
            if self.searchOpen {
                self.navigationItem.rightBarButtonItem = self.closeSearchBarButton
            } else {
                self.navigationItem.rightBarButtonItem = self.openSearchBarButton
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                collectionView.frame = CGRect(x: collectionView.frame.minX, y: collectionView.frame.minY + insetValue, width: collectionView.frame.width, height: collectionView.frame.height)
                collectionView.contentInset = UIEdgeInsets(top: collectionView.contentInset.top, left: collectionView.contentInset.left, bottom: collectionView.contentInset.bottom + insetValue, right: collectionView.contentInset.right)
                collectionView.scrollIndicatorInsets = UIEdgeInsets(top: collectionView.scrollIndicatorInsets.top, left: collectionView.scrollIndicatorInsets.left, bottom: collectionView.scrollIndicatorInsets.bottom + insetValue, right: collectionView.scrollIndicatorInsets.right)
                collectionView.collectionViewLayout.invalidateLayout()
                
                self.searchView.frame = CGRect(x: self.searchView.frame.minX, y: self.searchView.frame.minY + insetValue, width: self.searchView.frame.width, height: self.searchView.frame.height)
            }, completion: { (success) in
                self.searchView.inputTextField.text = ""
            })
        }
    }
    
    func handleOptionSelected(optionType: SideMenuOptionType) {
        
        if let sideMenuController = sideMenuController {
            if sideMenuController.sidePanelVisible {
                self.sideMenuController?.toggle()
            }
        }
        
        var filterApplied: Bool = false
        
        switch optionType {
        case .options:
            let optionsController = OptionsController(style: .grouped)
            optionsController.userDefaults = self.userDefaults
            navigationController?.pushViewController(optionsController, animated: true)
        case .suggestion:
            navigationController?.pushViewController(SuggestRaceController(), animated: true)
        case .about:
            navigationController?.pushViewController(AboutController(), animated: true)
        case .allRaces:
            filterRaces(filter: nil)
            filterApplied = true
        case .roadRaces:
            filterRaces(filter: raceType.estrada)
            filterApplied = true
        case .trailRaces:
            filterRaces(filter: raceType.trail)
            filterApplied = true
        case .otherRaces:
            filterRaces(filter: raceType.other)
            filterApplied = true
        }
        
        if searchOpen {
            handleToggleSearch(newFilterApplied: filterApplied)
        }
    }
    
}
