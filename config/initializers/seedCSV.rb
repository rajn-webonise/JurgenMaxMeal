

#init
require 'csv'

Restaurant.delete_all
Menu.delete_all
Item.delete_all

CSV.foreach(Rails.application.config.data_file) do |row|
  row.map!(&:lstrip)

  rid = 0

  if Restaurant.where(title: row[0]).blank?
    rid = Restaurant.create(title: row[0]).id
  else
    #debugger
    rid = Restaurant.find_by(title: row[0]).id
  end

  mid = Menu.create(price:row[1].to_f, rid:rid ).id

  i=0
  row.each do |x|
    if i<2
      i+=1
      next
    end

    item = Item.create(name:x, mid:mid)

  end

end
