class MyClass
    def first_method
      puts "Inside first method"
      if 1 < 2
        second_method  # calling second_method
      end
    end
    
    def second_method
      puts "Inside second method"
    end
  end
  
  my_object = MyClass.new
  my_object.first_method