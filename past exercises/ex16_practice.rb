#Get first object of user submitted array
chris_test = ARGV.first

puts "This is your file name: #{chris_test}"
puts "Lets erase it and add data. Press Return"

#gets input without reading it
$stdin.gets

#open file, makes it writable (truncates/erases contents), stores to target
puts "Opening #{chris_test}"
target = open(chris_test, 'w')

puts "Give me some dialog"
dialog = $stdin.gets.chomp

#writes dialog to target using write method
puts "Now I'll add the #{dialog} to the file"
target.write(dialog)

puts "All done"
target.close
