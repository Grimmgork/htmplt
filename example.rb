require "./lib/htmplt.rb"

engine = Htmplt.new

engine.template("index_page") do
	html do
		text "Hello world!"
	end
end

result = engine.run("index_page")

puts result