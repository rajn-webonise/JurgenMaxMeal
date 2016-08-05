
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
  
  def search
      data = CSV.read("config/sample_data.csv")
      params["answer"]=999

      answer = solve(data, params["q"].split(","))

      render text: data.to_s + "<br><br>Minimum cost: " + params["answer"].to_s
  end
  
end
