//
//  ChooseBusinessView.swift
//
//  Created on 4/2/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI
import RealmSwift

struct ChooseBusinessView: View {

    @Binding var selectedItem: BusinessPickerData
    @Binding var isAutofillItem: Bool
    @State private var searchText = ""
    @Environment(\.presentationMode) private var presentationMode

    @State private var state: States<BusinessPickerData> = .loaded([])
    @State private var notificationTokenSearch: NotificationToken?

    private let searchDebouncer = Debouncer(delay: Constants.debouncerDelaySeconds, handler: {})

    private enum States<Items> {
        case loading, empty, loaded(_: [Items])
    }

    private enum Dimensions {
        static let padding: CGFloat = 16.0
    }

    /// Interface

    var body: some View {
        VStack(spacing: Dimensions.padding / 2) {

            SearchBarView(searchText: searchTextBinding, placeholder: "Choose Business")

            ScrollView {
                VStack(spacing: .zero) {

                    VStack(alignment: .leading, spacing: .zero) {
                        SectionButton(title: "New Business", systemImageName: "plus", action: newBusinessClicked)
                            .padding(.vertical, Dimensions.padding)

                        Divider()
                    }

                    stateView()
                }
            }
                .padding(.horizontal, Dimensions.padding)
        }

            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
    }

    var searchTextBinding: Binding<String> {
        Binding<String>(
            get: { self.searchText },
            set: {
                self.searchText = $0

                self.searchDebouncer.invalidate()
                self.searchDebouncer.handler = { self.loadFilteredData(searchText: self.searchText) }
                self.searchDebouncer.call()
            }
        )
    }

    private func stateView() -> some View {
        switch state {
        case . loading:
            return AnyView(ActivityIndicator(isAnimating: .constant(true), style: .medium)
                .padding(.top, Dimensions.padding * 2))

        case .empty:
            return AnyView(EmptyStateView(searchWord: searchText))

        case .loaded(let items):
            return AnyView(listView(items: items))
        }
    }

    func listView(items: [BusinessPickerData]) -> some View {
        VStack(spacing: .zero) {
            ForEach(items) { item in
                Button(action: { self.searchItemClicked(item: item) }) {
                    BusinessPickerDataView(item: item)
                }
            }
        }
    }

    /// Actions

    private func onAppear() {
        loadFilteredData(searchText: "")
    }

    private func onDisappear() {
        notificationTokenSearch?.invalidate()
    }

    private func newBusinessClicked() {
        self.selectedItem = .notSelected
        self.isAutofillItem = false
        dismiss()
    }

    private func searchItemClicked(item: BusinessPickerData) {
        selectedItem = item
        dismiss()
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    /// Logic

    private func loadFilteredData(searchText: String) {
        let realmFilteredReports = RealmConnection.realm?.objects(Report.self)
        var result = realmFilteredReports

        if searchText != "" {
            let predicate = NSPredicate(format: "vessel.lastDelivery.business CONTAINS[cd] %@ OR vessel.lastDelivery.location CONTAINS[cd] %@",
                searchText, searchText)
            result = result?.filter(predicate)
        }

        result = result?.sorted(byKeyPath: "timestamp", ascending: false)

        guard let filteredReports = result else {
            return
        }

        notificationTokenSearch?.invalidate()

        state = .loading

        notificationTokenSearch = filteredReports.observe { change in

            switch change {
            case .initial:

                let businesses = self.formPickerData(reports: filteredReports)

                DispatchQueue.global().async {

                    let uniqueBusinesses = self.filterUniqueAndSort(data: businesses)

                    DispatchQueue.main.async {

                        if uniqueBusinesses.count > 0 {
                            self.state = .loaded(uniqueBusinesses)
                        } else {
                            self.state = .empty
                        }
                    }
                }

            case .update: do { }
            case .error(let error):
                print("Error - \(error)")
            }
        }
    }

    private func formPickerData(reports: Results<Report>) -> [BusinessPickerData] {
        var result = [BusinessPickerData]()
        for report in reports {
            if let delivery = report.vessel?.lastDelivery {
                let data = BusinessPickerData(business: delivery.business, location: delivery.location)
                result.append(data)
            }
        }
        return result
    }

    private func filterUniqueAndSort(data: [BusinessPickerData]) -> [BusinessPickerData] {
        var unique = [BusinessPickerData]()

        data.forEach {
            if !unique.contains($0) {
                unique.append($0)
            }
        }

        unique.sort {
            if $0.business == $1.business {
                return $0.location < $1.location
            } else {
                return $0.business < $1.business
            }
        }

        unique.removeAll { $0.business.isEmpty && $0.location.isEmpty }

        return unique
    }
}

struct ChooseBusinessView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedItem = BusinessPickerData(business: "P. Sherman", location: "Location")
        return ChooseBusinessView(selectedItem: .constant(selectedItem),
            isAutofillItem: .constant(true))
    }
}
