//
//  BaseCalendarViewController.swift
//  EmployeePortal
//
//  Created by sajeev Raj on 12/27/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import JTAppleCalendar

class BaseCalendarViewController: UIViewController, JTAppleCalendarViewDelegate, ActivityIndicatorPresenter {
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var calendarView: JTAppleCalendarView?
    var startDate: Date?
    var endDate: Date?
    var dateFormatter = DateFormatter()
    
    func monthTitle(for date: Date =  Date()) -> String {
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: date)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        configureCalendarProperties()
    }

    func configureCalendarProperties() {
        calendarView?.scrollDirection = .horizontal
        calendarView?.showsHorizontalScrollIndicator = false
        calendarView?.scrollingMode = .stopAtEachCalendarFrame
        calendarView?.minimumInteritemSpacing = 1
        calendarView?.minimumLineSpacing = 1
        calendarView?.backgroundColor = ThemeManager.Color.gray
    }
    
    func setRange() {
        if startDate == nil {
            let calendar = Calendar.current
            startDate = calendar.date(byAdding: .month, value: -6, to: Date())
        }
        
        if endDate == nil {
            let calendar = Calendar.current
            endDate = calendar.date(byAdding: .year, value: 3, to: startDate ?? Date())
        }
    }
    
    func registerNibs() {
        calendarView?.register(UINib(nibName: RosterDayCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RosterDayCollectionViewCell.identifier)
        
        calendarView?.register(UINib(nibName: DateHeaderJTAppleCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeaderJTAppleCollectionReusableView.identifier)
    }
    
    func configureCell(date: Date, view: JTAppleCell?, cellState: CellState) {
        handleCellTextColor(cell: view, cellState: cellState)
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? RosterDayCollectionViewCell  else { return }
        cell.dateLabel?.textColor =  cellState.dateBelongsTo == .thisMonth  ? .black : .gray
    }
    
    func configureDetailsPopUp(for roster: [Roster]?) {}
    
    // MARK: - JTAppleCalendarViewDelegate
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: RosterDayCollectionViewCell.identifier, for: indexPath) as? RosterDayCollectionViewCell else { return JTAppleCell()}
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(date: date,view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {}
    
    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {}

    func didChangeMonth(startDate : Date) {}

}

// MARK: - JTAppleCalendarViewDataSource
extension BaseCalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        setRange()
        return ConfigurationParameters(startDate: startDate!, endDate: endDate!,numberOfRows: 6,calendar: Calendar.current, generateOutDates: .off)
    }
}

// MARK: - Configure Month Header
extension BaseCalendarViewController {
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        guard let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: DateHeaderJTAppleCollectionReusableView.identifier, for: indexPath) as? DateHeaderJTAppleCollectionReusableView else { return JTAppleCollectionReusableView() }
        header.moveByIndex = { index in
            calendar.scrollToSegment(index > 0 ?.next : .previous)
        }

        header.monthTitleLabel?.text = monthTitle(for: range.start)
        didChangeMonth(startDate: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 75)
    }
}
