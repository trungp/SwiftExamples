//
//  CalendarViewController.swift
//  SwiftExamples
//
//  Created by Trung Pham on 3/7/16.
//  Copyright © 2016 Trung Pham. All rights reserved.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var eventStore : EKEventStore!
    var calendars: [EKCalendar]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventStore = EKEventStore()
        
        let tapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGesture")
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        saveButton.addTarget(self, action: Selector("saveButtonAction:"), forControlEvents: .TouchUpInside)
        
        // Config picker view
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Load calendar for picker view
        loadCalendars()
    }
    
    func loadCalendars() {
        validateAuthorizationStatus({ [weak self] in
            guard let this = self else { return }
            this.calendars = this.eventStore.calendarsForEntityType(.Event)
            this.pickerView.reloadAllComponents()
        })
    }
    
    // MARK: UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let calendars = calendars else { return 0 }
        return calendars.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let calendars = calendars else { return nil }
        let calendar = calendars[row]
        return calendar.title
    }
    
    // MARK: Button actions
    func saveButtonAction(button: UIButton) {
        validateAuthorizationStatus({ [weak self] in
            guard let this = self else { return }
            this.saveEvent()
        })
        
    }

    func validateAuthorizationStatus(closure: (() -> Void)?) {
        switch EKEventStore.authorizationStatusForEntityType(.Event) {
        case .Authorized:
            guard let closure = closure else { return }
            closure()
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Event) { (granted, error) in
                if granted {
                    guard let closure = closure else { return }
                    closure()
                } else {
                    print("Access denied")
                }
            }
        default: // Restricted
            print("Case Default")
        }
    }
    
    func saveEvent() {
        print("save event")
        eventStore.requestAccessToEntityType(.Event) { [weak self] (granted, error) in
            guard let this = self else { return }
            if !granted {
                print("Access denied")
            } else {
                
                let selectedCalendarIndex = this.pickerView.selectedRowInComponent(0)
                guard let calendars = this.calendars else {
                    print("No calendar for name")
                    return }
                let selectedCalendar = calendars[selectedCalendarIndex]
                
                let event = EKEvent(eventStore: this.eventStore)
                event.title = this.eventName.text!
                event.startDate = this.datePicker.date
                event.endDate = this.datePicker.date.dateByAddingTimeInterval(3600)
                event.calendar = selectedCalendar
                
                do {
                    try this.eventStore.saveEvent(event, span: EKSpan.ThisEvent)
                    
                    // Show message
                    let alert = UIAlertController(title: "Calendar", message: "Event created \(event.title) in \(selectedCalendar.title)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default, handler: nil))
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        this.presentViewController(alert, animated: true, completion: nil)
                    })
                    
                } catch {
                    // Failed
                    print("Failed, can not save event")
                }
            }
        }
    }
    
    // MARK: UITapGestureRecognizer
    func tapGesture() {
        eventName.resignFirstResponder()
    }
}
