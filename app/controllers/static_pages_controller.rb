
class StaticPagesController < ApplicationController
  
  def checkifmin(data, input, selected)
    #debugger
    inputsize = input.size
    cost = 0
    contains = 0
    #debugger if selected.size==1 && selected[0]==2
    selected.each do |current_menu_id|
    
      cost += data[current_menu_id][1].to_f
      #debugger
      for current_item_id in 2..(data[current_menu_id].size-1) 
        
          if input.include? data[current_menu_id][current_item_id]
            contains+=1
            input.delete data[current_menu_id][current_item_id]
          end
        
          
      end
      
      if contains >= inputsize && contains>0 && params["answer"] > cost
        params["answer"] = cost
        #debugger
      end
      
      #debugger if selected.size==1 && selected[0]==2

    end
      
  
    
    
    
  end
  
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
    
    checkifmin(data, input, selected)
      
  end
  
  
  def solve(data, input)
    selected = Array.new
    algorithm(data, input, selected, 0)
    #debugger
    
  end
  
  def home
        data = CSV.read("config/sample_data.csv")
        params["answer"]=999
        #debugger
        answer = solve(data, [" xyz"])
        #debugger
        render text: data.to_s + "<br><br>" + params["answer"].to_s
  end

  def help
  end
end
