
class StaticPagesController < ApplicationController

  def checkifmin(data, input, selected)
    #debugger if !selected.include? 6
    inputs = input.clone
    inputsize = inputs.size
    cost = 0
    contains = 0

    selected.each do |current_menu_id|

      cost += data[current_menu_id][1].to_f

      for current_item_id in 2..(data[current_menu_id].size-1)

          if inputs.include? data[current_menu_id][current_item_id]
            contains+=1
            inputs.delete data[current_menu_id][current_item_id]
          end

      end

      if contains >= inputsize && contains>0 && params["answer"] > cost
        params["answer"] = cost
        #debugger
      end

    end

  end

  # This algorithm generates all possible inputs
  def algorithm(data, input, selected, depth)

    if depth >= data.size
      return
    end

    checkifmin(data, input, selected)

    selected.push depth
    algorithm(data, input, selected, depth+1)

    checkifmin(data, input, selected)

    selected.pop

    algorithm(data, input, selected, depth+1)
    #debugger if input.size==0
    checkifmin(data, input, selected)

  end

  def solve(datas, input)
    selected = Array.new
    algorithm(datas, input, selected, 0)
  end

  def home
  end

  def help
  end

  def combo_cost_evaluator(current_combo)
    inputs = params["q"].split(" ")
    cost = 0.0
#    debugger if current_combo.size == 2
    #loop through each menu in a combo
    current_combo.each do |menu|
      cost += menu.price.to_f
      items = Item.where(mid: menu.id).to_a
      #loop through each item in a menu
      items.each do |item|
  #      debugger if current_combo.size == 2
        if inputs.include? item.name
          inputs.delete item.name
        end

      end
#     debugger if current_combo.size == 2
    end
    if inputs.size!=0
      cost = -1.0
    end
#    debugger if current_combo.size == 2
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
      #debugger
      #Try every possible combination of menu in a restaurant
      #Combinations of different lengths
      for combo_size in 1..m.size-1
        current_combo_lot = m.combination(combo_size).to_a

        current_combo_lot.each do |current_combo|
          current_combo_cost = combo_cost_evaluator(current_combo)
          if (current_combo_cost>0 && (minimum_cost<0 || minimum_cost > current_combo_cost))
            minimum_cost = current_combo_cost
            minimum_mids.clear
            minimum_mids = current_combo.clone
          end

        end
      end

      #debugger
    end
    render text: "br><br>Minimum cost: "+ minimum_cost.to_s + " and mids: " + minimum_mids.to_s

    #  answer = solve(data, params["q"].split(","))#  render text: data.to_s + "<br><br>Minimum cost: " + params["answer"].to_s
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
