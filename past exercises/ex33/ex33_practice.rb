def number_array()
    print "Can I get a number? \n"
    number = gets.chomp
    numbers = []
    i = 0

    while i < number.to_i 
        #puts "I am going to print out your number #{numbers}" #string interpolation
        puts "I am going to print out your number", numbers #print array
        numbers.push(i)
        i += 1
    end
    
end

number_array()