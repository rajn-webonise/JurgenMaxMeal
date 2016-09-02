
class StaticPagesController < ApplicationController

  def home
  end

  def help
  end

  def combo_cost_evaluator(current_combo)
    inputs = params["q"].split(" ")
    cost = 0.0
    current_combo.each do |menu|
      cost += menu.price.to_f
      items = Item.where(mid: menu.id).to_a
      #loop through each item in a menu
      items.each do |item|
        if inputs.include? item.name
          inputs.delete item.name
        end
      end
    end
    if inputs.size!=0
      cost = -1.0
    end
    return cost
  end

  def search
    input = params["q"].split(" ") # try to replace on combo_cost_evaluator function

    rids = Restaurant.select(:id).map(&:id).uniq
    minimum_mids = Array.new
    minimum_cost = -1.0
    # Loop through every restaurant.
    rids.each do |rid|
      m = Menu.select("id", "price").where(rid: rid)

      #Try every possible combination of menu in a restaurant
      #Combinations of different lengths
      for combo_size in 1..m.size

        current_combo_lot = m.combination(combo_size).to_a
        #byebug
        current_combo_lot.each do |current_combo|
          current_combo_cost = combo_cost_evaluator(current_combo)

          if (current_combo_cost>0 && (minimum_cost<0 || minimum_cost > current_combo_cost))
            minimum_cost = current_combo_cost
            minimum_mids.clear
            minimum_mids = current_combo.clone
          end

        end
      end

    end

    if minimum_cost>0
      params["output"] = "You can eat at restaurant#ID " + Restaurant.find_by(id: Menu.find_by( id: (minimum_mids[0].id).to_i ).rid ).title + " for a price of " + minimum_cost.to_s
    else
      params["output"] = "Sorry, no restaurant serves this combination!"
    end

  end

end



=begin
Hotel
rid

Menu
mid price rid


Item
iid name mid
=end
