# Ruby Cheatsheet

* Author:
	* Sergio Quijano Rey
	* [Email](sergiquijano@gmail.com)
	* [Github](https://github.com/sergioquijanorey)

--------------------------------------------------------------------------------

## Terminal IO

* `puts "Hello world"`: prints the content and also a new line
* `print "Hello world"`: prints the content without the new line
* `puts ("Hello my name is " + character_name ", how are you?")`
* `variable = gets`: gets information from the terminal. New line character is also stored
* `variable = gets.chomp()`: same as before, new line character is ignored
* `variable = gets.chomp().to_f`: gets a floating point number
* `variable = gets.chomp().to_i`: gets a integer

--------------------------------------------------------------------------------

## Data types

* String: `"data"`
* Numbers
	* Integer: `12`
	* Float: `12.123`
* Boolean: `true false`
* Null value: `name = nil`
* Array: `name = Array[<values>]`
* Hash Table 

### String Methods

* `str.upcase()`: converts to uppercase
* `str.downcase()`: converts to downcase
* `str.strip()`: removes initial and end spaces or tabs
* `str.length()`: length of the string
* `str.index("substr")`: index of first time found substr
* `str.include? "substr"`: checks whether substr is in the string or not
* `str[<range expr>]`: gets a substring specified by range
* `str * <number>`: appends `number` of times the string
* `String.try_convert(<something>)`: in success, returns the conversion to string. Otherwise, returns `nil`
* `<Something>.to_s`: converts `something` to string. It doesn't check anything

### Number Methods

* `val.abs()`
* `val.round()`
* `val.ceil()`
* `val.floor()`
* `val.to_i`: converts to integer
* `val.to_f`: converts to float
* `Math` class: where a lot of mathematical functions are available
	* `Math.sqrt(num)`
	* `Math.log(num)`


**Showcase example**:

~~~ruby
msg = "My name is Sergio"

puts msg.upcase()
puts msg.downcase()
puts msg.strip()
puts msg.length()
puts msg[1]
puts msg[0,3]
puts msg.index("name")
puts msg.include? "is"
~~~

### Array Methods

* Initialize: `friends = Array["Antonio", "Lucia", "Celia"]`
* `array.length`
* `array.include? element`
* `array.reverse()`
* `array.sort()`: throws an error if there are different data types stored
* `array[<range expr>]`

### Hash Methods

**Showcase**:

~~~ruby
states = {
	"Cantabria" => "CA"
	"Granada" => "GR",
	"Madrid" => "MR"
}

states2 = {
	2 => "Sergio",
	"Antonio" => "Merino",
	:stock_price => 12.3
}

puts states[1]
puts states["Cantabria"]
puts states2[:stock_price]
~~~

--------------------------------------------------------------------------------

## Methods

### Definition of a method

If the method needs parameters:

~~~ruby
def methodname(parameters)
	<codeblock>
end

def methodname(par1 = deval1, par2 = defval2 ...)
	<codeblock>
end
~~~

If the method doesn't need parameters we can also do:

~~~ruby
def methodname
	<codeblock>
end
~~~

### Calling a method

~~~ruby
methodname(parameters)
methodname	# If no parameters are needed
~~~

--------------------------------------------------------------------------------

## Control statements and loops

### Boolean expressions

~~~ruby
cond1 or cond2
cond1 and cond2
!cond1
~~~

### If statement

~~~ruby
if <boolean_expression>
	<code>
elsif <boolean_expression>
	<code>
else
	<code>
end
~~~

### Case statement

~~~ruby
case value
when val1
	<code>
when val2
	<code>
else
	<default_code>
end
~~~

### While loop

~~~ruby
while <condition>
	<code>
end
~~~

### For loop

~~~ruby
# For type 1 : For each
for val in <iterable>
	<code>
end

# For type 2 : For each
<iterable>.each do |val|
	<code>
end

# For type 3 : range of numbers
for index in <start>..<end>
	<code>
end

# For type 4 : range of numbers
<number>.times do |index|
	<code>
end

~~~

--------------------------------------------------------------------------------

## File IO

### Opening a file

* Opening modes can be found [here](https://stackoverflow.com/questions/3682359/what-are-the-ruby-file-open-modes-and-options)

~~~ruby
# Method 1: block mode
File.open(<path>, <opening_mode>) do |file|
	<code>
end

# Method 2: variable mode

file = File.open(<path>, <opening_mode>)
...
<code>
...
file.close() 	# Very important
~~~

### File operations

~~~ruby
file.read() 		# Reads all the data in the file
file.readline()		# Reads one line at a time
file.readchar()		# Reads one char at a time
file.readlines()	# Returns an array with all the lines
file.write(str)		# Writes on the file

# Simplest way of pulling data from a file
for line in file.readlines()
	# Operate with a line at a time
end
~~~

--------------------------------------------------------------------------------

## Error handling

* All error types can be found [here](https://ruby-doc.org/core-2.2.0/Exception.html)

~~~ruby
begin
	<dangerous_code>
rescue <Error_exception> => error_holder
	<Error handling>
rescue
	<Default error handling>
end
~~~

--------------------------------------------------------------------------------

## Classes 

### Definition

~~~ruby
class Classname
	attr_accessor :data1, :data2, :data3 ....
	
	def initialize(param1, param2, param3 ...)
		@data1 = param1
		@data2 = param2
		@data3 = param3
		
		....
		
	end
end

instance = Classname.new(param1, param2, param3 ... )
~~~


### Showcase

~~~ruby
#!/usr/bin/env ruby

class Book
	attr_accessor :title, :author, :pages
	def initialize(title, author, pages)
		@title = title
		@author = author
		@pages = pages
		
	end

	def display()
		puts "Title: " + @title
		puts "Author: " + @author
		puts "Pages: " + @pages.to_s
	end
end


hp = Book.new("Harry Potter", "JK Rowling", 400)
hp.display()
~~~

--------------------------------------------------------------------------------

## Miscelaneous

* Shebang: `!#/usr/bin/env ruby`
* Comments:
	* `# One line comment`
	* `=begin
		Multi line comment
		More lines
	   =end`
