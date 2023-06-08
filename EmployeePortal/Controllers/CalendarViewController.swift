//
//  CalendarViewCOntroller.swift
//  EmployeePortal
//
//  Created by sajeev Raj on 12/24/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import JTAppleCalendar

struct LoadedMonth:Equatable {
    var year: Int?
    var month: Int?
}

class CalendarViewController: BaseCalendarViewController {
    
    @IBOutlet weak var addOptionsView: View?
    @IBOutlet weak var addOptionsViewHeightConstraint: NSLayoutConstraint?
    
    var roasters = [Date:[Roster]]() {
        didSet {
            calendarView?.reloadData()
        }
    }
    
    var loadedMonths = [LoadedMonth]()
    var addOptionsViewHeight:CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView?.calendarDataSource = self
        calendarView?.ibCalendarDataSource = self
        calendarView?.calendarDelegate = self
        calendarView?.ibCalendarDelegate = self
        addNavigationButton(option: .back)
        configureAddOptionsView()
        calendarView?.scrollToDate(Date())
        initialCalendarDetailFetch()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Roster"
        
    }
    
    func initialCalendarDetailFetch() {
        // call the calendar details with current date month (3 months - last, this and next month)
        let thirtyDaysTimeInterval:TimeInterval = 60*60*24*30
        if let fromDate = Date().addingTimeInterval(-thirtyDaysTimeInterval).startOfMonth(),
            let toDate = Date().addingTimeInterval(thirtyDaysTimeInterval).endOfMonth() {
            
            // added to loaded months
            loadedMonths.append(LoadedMonth(year: fromDate.year, month: fromDate.month))
            loadedMonths.append(LoadedMonth(year: Date().year, month: Date().month))
            loadedMonths.append(LoadedMonth(year: toDate.year, month: toDate.month))
            
            //getdetails
            getCalendarDetails(from:fromDate,to:toDate)
        }
    }
    
    func configureAddOptionsView() {
        addOptionsViewHeightConstraint?.constant = 0
        addOptionsView?.alpha = 0
    }
    
    func animateOptionsView(shouldShow: Bool = true) {
        let finalHeight = shouldShow ? addOptionsViewHeight : 0
        addOptionsViewHeightConstraint?.constant = finalHeight

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.addOptionsView?.alpha = shouldShow ? 1 : 0
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - IBAction
    @IBAction func addButtonAction(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        animateOptionsView(shouldShow: sender.isSelected )
    }
    
    @IBAction func addTimeSheetButtonAction(sender : UIButton) {
        TimesheetViewController.show()
    }
    
    @IBAction func addLeaveAction(sender : UIButton) {
        LeaveViewController.show()
    }

    override func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        print(visibleDates.monthDates)
        print(visibleDates.outdates)
        print(visibleDates.indates)
    }

    
    override func configureCell(date: Date,view: JTAppleCell?, cellState: CellState) {
       
        super.configureCell(date: date, view: view, cellState: cellState)
        guard let cell = view as? RosterDayCollectionViewCell  else { return }
        if let roasters = roasters[date.startOfDay()] {
            cell.rosters = roasters
        } else {
            cell.rosters = []
        }
        cell.dateLabel?.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    override func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let rosterCell = cell as? RosterDayCollectionViewCell else { return }
        
        guard let roasterDetailsView = RoasterDetails.instantiateFromNib() as? RoasterDetails else { return }
        roasterDetailsView.rosters = rosterCell.rosters ?? []
        self.view.addSubview(roasterDetailsView)
        roasterDetailsView.fillInSuperView()
        view.bringSubviewToFront(roasterDetailsView)
        roasterDetailsView.dismissView = { [weak self] in
            roasterDetailsView.removeFromSuperview()
        }
    }
    
    override func didChangeMonth(startDate : Date) {
        let selectedMonth = LoadedMonth(year: startDate.year, month: startDate.month)
        let alreadyLoadedMonth = loadedMonths.contains(selectedMonth)
        guard !alreadyLoadedMonth else {
            // this month is already present
            return
        }
        loadedMonths.append(selectedMonth)
        getCalendarDetails(from: startDate.startOfMonth(),to:startDate.endOfMonth() )
    }
    
    private func getCalendarDetails( from fromDate: Date?,to toDate: Date?) {
        
        showLoader()
        Roster.getRosters(from: fromDate, to: toDate) { [weak self] (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let rosterList):
                    self?.addRoastersToList(rosterList: rosterList)
                case .failure(let error):
                    AlertController.show(type: .serviceError, error: error, successHandler: nil, cancelHandler: nil)
                case .finally:
                    self?.hideLoader()
                }
            }
        }
    }
    
    func addRoastersToList(rosterList : [Roster]) {
        var roasterDict = [Date:[Roster]]()
        rosterList.forEach { (roster) in
            if let _ = roasterDict[roster.date.startOfDay()] {
                roasterDict[roster.date.startOfDay()]?.append(roster)
            } else {
                roasterDict[roster.date.startOfDay()] = [roster]
            }
        }
        self.roasters = self.roasters.merged(with: roasterDict)
    }
}

extension CalendarViewController: NavigationBarOptions {}


