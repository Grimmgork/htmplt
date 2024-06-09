require 'cgi'

class TemplateParams
	def initialize()
		@params = {}
	end

	def [](name)
		@params[name]
	end

	def []=(name, value)
		@params[name] = value
	end

	def method_missing(method_name, *args, &block)
		return @params[method_name] if @params.has_key?(method_name)
	end
end
  

class Template

	def initialize(result, templates, renderer, parent, &block)
		@templates = templates
		@result = result
		@params = TemplateParams.new
		@parent = parent
		@renderer = renderer
		@context = nil

		# TODO parent is all the same -> ROOT?
		# move templates and result to parent??
		instance_exec(&block) if block_given? # configurator
	end

	def param(name, value=nil, &block)
		if block_given?
			@params[name] = block
		else
			@params[name] = value
		end
	end

	def params
		@params
	end

	def context(value)
		@context = value
	end

	def render()
		instance_exec(&@renderer)
	end

	def render_param(name, render_context=nil)
		renderer = @params[name]
		# solve problem where @parent can be nil if it has no parent
		@parent.instance_exec(render_context, &renderer) if renderer
	end

	def template(name, &block)
		# TODO prevent infinite loop?
		Template.new(@result, @templates, @templates[name], self, &block).render()
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

	def head(**attributes, &block)
		tag("head", attributes, &block)
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

	def a(**attributes, &block)
		inline("a", attributes, &block)
	end

	def p(**attributes, &block)
		tag("p", attributes, &block)
	end

	def head(**attributes, &block)
		tag("head", attributes, &block)
	end
	
	def title(**attributes, &block)
		tag("title", attributes, &block)
	end
	
	def base(**attributes, &block)
		tag("base", attributes, &block)
	end
	
	def link(**attributes, &block)
		tag("link", attributes, &block)
	end
	
	def meta(**attributes, &block)
		tag("meta", attributes, &block)
	end
	
	def style(**attributes, &block)
		tag("style", attributes, &block)
	end
	
	def noscript(**attributes, &block)
		tag("noscript", attributes, &block)
	end
	
	def body(**attributes, &block)
		tag("body", attributes, &block)
	end
	
	def section(**attributes, &block)
		tag("section", attributes, &block)
	end
	
	def nav(**attributes, &block)
		tag("nav", attributes, &block)
	end
	
	def article(**attributes, &block)
		tag("article", attributes, &block)
	end
	
	def aside(**attributes, &block)
		tag("aside", attributes, &block)
	end
	
	def h1(**attributes, &block)
		tag("h1", attributes, &block)
	end

	def h2(**attributes, &block)
		tag("h2", attributes, &block)
	end

	def h3(**attributes, &block)
		tag("h3", attributes, &block)
	end

	def h4(**attributes, &block)
		tag("h4", attributes, &block)
	end

	def h5(**attributes, &block)
		tag("h5", attributes, &block)
	end

	def h6(**attributes, &block)
		tag("h6", attributes, &block)
	end
	
	def header(**attributes, &block)
		tag("header", attributes, &block)
	end
	
	def footer(**attributes, &block)
		tag("footer", attributes, &block)
	end
	
	def address(**attributes, &block)
		tag("address", attributes, &block)
	end
	
	def main(**attributes, &block)
		tag("main", attributes, &block)
	end
	
	def hr(**attributes, &block)
		tag("hr", attributes, &block)
	end
	
	def pre(**attributes, &block)
		tag("pre", attributes, &block)
	end
	
	def blockquote(**attributes, &block)
		tag("blockquote", attributes, &block)
	end
	
	def ol(**attributes, &block)
		tag("ol", attributes, &block)
	end
	
	def ul(**attributes, &block)
		tag("ul", attributes, &block)
	end
	
	def li(**attributes, &block)
		tag("li", attributes, &block)
	end
	
	def dl(**attributes, &block)
		tag("dl", attributes, &block)
	end
	
	def dt(**attributes, &block)
		tag("dt", attributes, &block)
	end
	
	def dd(**attributes, &block)
		tag("dd", attributes, &block)
	end
	
	def figure(**attributes, &block)
		tag("figure", attributes, &block)
	end
	
	def figcaption(**attributes, &block)
		tag("figcaption", attributes, &block)
	end
	
	def em(**attributes, &block)
		tag("em", attributes, &block)
	end
	
	def strong(**attributes, &block)
		tag("strong", attributes, &block)
	end
	
	def small(**attributes, &block)
		tag("small", attributes, &block)
	end
	
	def s(**attributes, &block)
		tag("s", attributes, &block)
	end
	
	def cite(**attributes, &block)
		tag("cite", attributes, &block)
	end
	
	def q(**attributes, &block)
		tag("q", attributes, &block)
	end
	
	def dfn(**attributes, &block)
		tag("dfn", attributes, &block)
	end
	
	def abbr(**attributes, &block)
		tag("abbr", attributes, &block)
	end
	
	def data(**attributes, &block)
		tag("data", attributes, &block)
	end
	
	def time(**attributes, &block)
		tag("time", attributes, &block)
	end
	
	def code(**attributes, &block)
		tag("code", attributes, &block)
	end
	
	def var(**attributes, &block)
		tag("var", attributes, &block)
	end
	
	def samp(**attributes, &block)
		tag("samp", attributes, &block)
	end
	
	def kbd(**attributes, &block)
		tag("kbd", attributes, &block)
	end
	
	def sub(**attributes, &block)
		tag("sub", attributes, &block)
	end
	
	def sup(**attributes, &block)
		tag("sup", attributes, &block)
	end
	
	def i(**attributes, &block)
		tag("i", attributes, &block)
	end
	
	def b(**attributes, &block)
		tag("b", attributes, &block)
	end
	
	def u(**attributes, &block)
		tag("u", attributes, &block)
	end
	
	def mark(**attributes, &block)
		tag("mark", attributes, &block)
	end
	
	def ruby(**attributes, &block)
		tag("ruby", attributes, &block)
	end
	
	def rt(**attributes, &block)
		tag("rt", attributes, &block)
	end
	
	def rp(**attributes, &block)
		tag("rp", attributes, &block)
	end
	
	def bdi(**attributes, &block)
		tag("bdi", attributes, &block)
	end
	
	def bdo(**attributes, &block)
		tag("bdo", attributes, &block)
	end
	
	def br(**attributes)
		single("br", attributes)
	end
	
	def wbr(**attributes, &block)
		tag("wbr", attributes, &block)
	end
	
	def ins(**attributes, &block)
		tag("ins", attributes, &block)
	end
	
	def del(**attributes, &block)
		tag("del", attributes, &block)
	end
	
	def img(**attributes, &block)
		tag("img", attributes, &block)
	end
	
	def iframe(**attributes, &block)
		tag("iframe", attributes, &block)
	end
	
	def embed(**attributes, &block)
		tag("embed", attributes, &block)
	end
	
	def object(**attributes, &block)
		tag("object", attributes, &block)
	end
	
	def video(**attributes, &block)
		tag("video", attributes, &block)
	end
	
	def audio(**attributes, &block)
		tag("audio", attributes, &block)
	end
	
	def source(**attributes, &block)
		tag("source", attributes, &block)
	end
	
	def track(**attributes, &block)
		tag("track", attributes, &block)
	end
	
	def canvas(**attributes, &block)
		tag("canvas", attributes, &block)
	end
	
	def map(**attributes, &block)
		tag("map", attributes, &block)
	end
	
	def area(**attributes, &block)
		tag("area", attributes, &block)
	end
	
	def svg(**attributes, &block)
		tag("svg", attributes, &block)
	end
	
	def math(**attributes, &block)
		tag("math", attributes, &block)
	end
	
	def table(**attributes, &block)
		tag("table", attributes, &block)
	end
	
	def caption(**attributes, &block)
		tag("caption", attributes, &block)
	end
	
	def colgroup(**attributes, &block)
		tag("colgroup", attributes, &block)
	end
	
	def col(**attributes, &block)
		tag("col", attributes, &block)
	end
	
	def tbody(**attributes, &block)
		tag("tbody", attributes, &block)
	end
	
	def thead(**attributes, &block)
		tag("thead", attributes, &block)
	end
	
	def tfoot(**attributes, &block)
		tag("tfoot", attributes, &block)
	end
	
	def tr(**attributes, &block)
		tag("tr", attributes, &block)
	end
	
	def td(**attributes, &block)
		tag("td", attributes, &block)
	end
	
	def th(**attributes, &block)
		tag("th", attributes, &block)
	end
	
	def form(**attributes, &block)
		tag("form", attributes, &block)
	end
	
	def fieldset(**attributes, &block)
		tag("fieldset", attributes, &block)
	end
	
	def legend(**attributes, &block)
		tag("legend", attributes, &block)
	end
	
	def label(**attributes, &block)
		tag("label", attributes, &block)
	end
	
	def input(**attributes, &block)
		tag("input", attributes, &block)
	end
	
	def button(**attributes, &block)
		tag("button", attributes, &block)
	end
	
	def select(**attributes, &block)
		tag("select", attributes, &block)
	end
	
	def datalist(**attributes, &block)
		tag("datalist", attributes, &block)
	end
	
	def optgroup(**attributes, &block)
		tag("optgroup", attributes, &block)
	end
	
	def option(**attributes, &block)
		tag("option", attributes, &block)
	end
	
	def textarea(**attributes, &block)
		tag("textarea", attributes, &block)
	end
	
	def keygen(**attributes, &block)
		tag("keygen", attributes, &block)
	end
	
	def output(**attributes, &block)
		tag("output", attributes, &block)
	end
	
	def progress(**attributes, &block)
		tag("progress", attributes, &block)
	end
	
	def meter(**attributes, &block)
		tag("meter", attributes, &block)
	end
	
	def details(**attributes, &block)
		tag("details", attributes, &block)
	end
	
	def summary(**attributes, &block)
		tag("summary", attributes, &block)
	end
	
	def command(**attributes, &block)
		tag("command", attributes, &block)
	end
	
	def menu(**attributes, &block)
		tag("menu", attributes, &block)
	end	
end

class Htmplt

	def initialize()
		@templates = {}
	end

	def register(name, &block)
		@templates[name] = block
		self
	end

	def run(name=nil, result="", &block)
		renderer = block
		renderer = @templates[name] if name
		Template.new(result, @templates, renderer, Template.new(result, @templates, renderer, nil), &block).render()
		result
	end
end

engine = Htmplt.new
engine.register "template" do
	text "hello there!"
	params.items.each do |item|
		render_param(:item_template, item)
	end
end

i = 10
print(
engine.run("template") do
	param :items, [10, 20, 30, 40]
	param :item_template do |item|
		text (item + i).to_s
	end
end)
