module ApplicationHelper
  
  def number_to_currency(number, options = {})
    options[:locale] ||= I18n.locale
    super(number, options)
  end
  
  def restaurant_count(account_id)
    Restaurant.where(:account_id => account_id).count
  end
  
  def table_count(restaurant_id)
    Table.where(:restaurant_id => restaurant_id).count
  end
  
  def max_diners_at_current_time(restaurant_id)
    Rdetail.where(:restaurant_id => restaurant_id)[0].max_diners_at_current_time
 end
 
end
