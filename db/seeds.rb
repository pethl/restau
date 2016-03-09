# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Account.create(company_name: 'Hang Fire Smoke House Co', primary_contact: 'Shauna Guinn', email: 'hangfirebbq@gmail.com', phone:'07803293552')
Restaurant.create(account_id: '1', name: 'Hang Fire Southern Kitchen', location: 'Pump House, Barry', website: 'hangfirebbq.com', primary_contact: 'Sam Evans', email: 'hangfirebbq@gmail.com', phone:'07803293552')
Rdetail.create(restaurant_id: '1', booking_duration: '2', min_booking: '1', max_booking: '10', max_diners_at_current_time: '23', max_current_diners: '48', current_diners_window_start: '90', current_diners_window_end: '45', big_table_count: '2', large_table_count: '4', safe_float: 1000, till_float_main: 200, till_float_bar: 100, eve_full_diners: 50, day_full_diners: 110, afternoon_full_diners: 50)
Error.create(ref: '999999101', msg: 'Please enter all required information.', desc: 'Validation - Booking enquiry : Check all fields have been entered.')
Error.create(ref: '999999102', msg: 'Bookings can only be made for today or future dates, please amend date and try again.', desc: 'Validation - Booking enquiry : Check booking not in the past.')
Error.create(ref: '999999103', msg: 'The restaurant is closed on Mondays and Tuesdays, please amend date and try again.', desc: 'Validation - Booking enquiry : Check booking not made when restaurant is closed.')
Error.create(ref: '999999104', msg: 'The restaurant opens at 5pm on this day, please amend booking time and try again.', desc: 'Validation - Booking enquiry : User tried to book outside opening hours on Wed, Thurs, Fri.')
Error.create(ref: '999999105', msg: 'The restaurant closes at 6pm on this day, please amend booking time and try again.', desc: 'Validation - Booking enquiry : User tried to book outside opening hours on Sun.')
Error.create(ref: '999999106', msg: 'We are sorry, we cannot accomodate your party at this time as the restaurant is busy. Please try again.', desc: 'Validation - Booking enquiry : Cannot accomodate due to volume of current diners or diners at same time.')
Error.create(ref: '999999107', msg: 'We are sorry, we already have a number of large parties booked for this day and cannot accommodate your group. Please try for another day or a smaller group.', desc: 'Validation - Booking enquiry. Cannot accommodate more than PARAM-MAX big parties of PARAM-BIG size.')
Error.create(ref: '999999108', msg: 'We are sorry, we already have a number of large parties booked for this day and cannot accommodate your group. Please try for another day or a smaller group.', desc: 'Validation - Booking enquiry. Cannot accommodate more than PARAM-MAX large parties of PARAM-LARGE size.')
Error.create(ref: '999999109', msg: 'Sorry, there has been a system error. Please re-try.', desc: 'Validation - Booking enquiry. Non-specific fault, system error.')
Error.create(ref: '999999110', msg: 'We are fully booked at your requested time, but we do have a table 15 mins earlier.', desc: 'Confirmation - Booking Enquiry - Table available 15 mins earlier.')
Error.create(ref: '999999111', msg: 'We are fully booked at your requested time, but we do have a table 15 mins later.', desc: 'Confirmation - Booking Enquiry - Table available 15 mins later.')
Error.create(ref: '999999112', msg: 'Online bookings cannot be made for same day. We aim to keep tables free for walk-ups each day, but try to avoid peak times.', desc: 'Validation - Booking enquiry Booking for today cannot be made online.')
Error.create(ref: '999999113', msg: 'The information you have entered does not match your booking, please try again or get in touch via our website form.', desc: 'Error given when customer tries to cancel booking but information given doesnot match booking phone or email.')
Error.create(ref: '999999114', msg: 'Please enter phone number OR email used to confirm this booking. Your booking has not been cancelled.', desc: 'Error given when user tries to cancel a booking but has not entered any data.')
Error.create(ref: '999999115', msg: 'The restaurant does not open until March 9th, 2016. Please try to book after this date.', desc: 'Customer tried to book before March 9th 2016.')