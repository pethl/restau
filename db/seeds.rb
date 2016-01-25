# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Account.create(company_name: 'Hang Fire Smoke House Co', primary_contact: 'Shauna Guinn', email: 'hangfirebbq@gmail.com', phone:'07803293552')
Restaurant.create(name: 'Hang Fire Southern Kitchen', location: 'Pump House, Barry', website: 'hangfirebbq.com', primary_contact: 'Sam Evans', email: 'hangfirebbq@gmail.com', phone:'07803293552')
Rdetail.create(restaurant_id: '1', booking_duration: '2', min_booking: '1', max_booking: '10', max_diners_at_current_time: '23', max_current_diners: '40', current_diners_window_start: '90', current_diners_window_end: '45', big_table_count: '2', large_table_count: '4')
Error.create(ref: '101', msg: 'Please enter all required information.', desc: 'Validation - Booking enquiry : Check all fields have been entered.')
Error.create(ref: '102', msg: 'Bookings can only be made for future dates, please amend date and try again.', desc: 'Validation - Booking enquiry : Check booking in future.')
Error.create(ref: '103', msg: 'The restaurant is closed on Mondays and Tuesdays, please amend date and try again.', desc: 'Validation - Booking enquiry : Check booking not made when restaurant is closed.')
Error.create(ref: '104', msg: 'The restaurant opens at 5pm on this day, please amend booking time and try again.', desc: 'Validation - Booking enquiry : User tried to book outside opening hours on wed, thurs, Fri')