require 'cgi'

class Template

	def initialize(result, templates, render, parent, &block)
		@templates = templates
		@result = result
		@param = {}
		@parent = parent

		# TODO parent is all the same -> ROOT?
		# move templates and result to parent??

		instance_exec(&block) if block_given? # configurator
		instance_exec(&render) # renderer
	end

	def param(name, value=nil, &block)
		if block_given?
			@param[name] = block
		else
			@param[name] = value
		end
	end

	def render_param(name, context=nil)
		render = @param[name]
		@parent.instance_exec(context, &render) if render
	end

	def template(name, &block)
		# TODO prevent infinite loop?
		Template.new(@result, @templates, @templates[name], self, &block)
	end

	def hash_to_attributes(hash)
		result = ""
		attributes = hash.keys.map do |name|
			value = hash[name]
			next if value == nil or value == ""
			result << " #{name.to_s.gsub('_', '-')}=\"#{CGI::escapeHTML(value)}\""
		end
		result
	end

	
	# HTML Elements
	def unsafe(text)
		@result << text
	end

	def text(text)
		@result << CGI::escapeHTML(text || "")
	end

	def tag(symbol, attributes={}, &block)
		unsafe "<#{symbol}#{hash_to_attributes(attributes)}>"
		instance_exec(&block) if block_given?
		unsafe "</#{symbol}>"
	end

	def inline(symbol, attributes={}, &block)
		unsafe "<#{symbol}#{hash_to_attributes(attributes)}></#{symbol}>"
	end

	def single(symbol, attributes={})
		unsafe "<#{symbol}#{hash_to_attributes(attributes)}/>"
	end

	def html(**attributes, &block)
		unsafe("<!DOCTYPE html>")
		tag("html", attributes, &block)
	end

	def script(content=nil, **attributes) 
		tag("script", attributes) do 
	        text(content)
	    end
	end

	def div(**attributes, &block)
		tag("div", attributes, &block)
	end

	def span(text=nil, **attributes, &block)
		if block_given? or not text
			inline("span", attributes, &block)
		else
			inline("span", attributes) do
				text(text)
			end
		end
	end
end

class Htmpl

	def initialize()
		@templates = {}
	end

	def register(name, &block)
		@templates[name] = block
	end

	def run(name=nil, &block)
		@result = []
		if not name
			Template.new(@result, @templates, block, nil)
		else
			Template.new(@result, @templates, @templates[name], nil, &block)
		end
		@result
	end
end