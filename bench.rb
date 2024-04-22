require 'erb'
require 'haml'
require 'slim'
require 'benchmark'
require 'ostruct'
require "./lib/htmplt.rb"
require "./new.rb"

notes = OpenStruct.new title: 'Write an essay', description: 'My essay is about...', randomList: (0..50).to_a.sort{ rand() - 0.5 }[0..10000]

erb_example = <<-ERB_EXAMPLE
<span><%= notes.title %></span>
<span><%= notes.description %></span>
<table>
  <tr>
    <% notes.randomList.each do |note| %>
      <td><%= note %></td>
    <% end %>
  </tr>
</table>
ERB_EXAMPLE

slim_example = <<-SLIM_EXAMPLE
span= notes.title
span= notes.description
table
  tr
    - notes.randomList.each do |note|
      td= note
SLIM_EXAMPLE

haml_example = <<-HAML_EXAMPLE
%span= notes.title
%span= notes.description
%table
  %tr
    - notes.randomList.each do |note|
      %td= note
HAML_EXAMPLE

engine = Htmpl.new()
engine.register "notes" do
	context = @param[:notes]
	span context.title
	span context.description
	tag "table" do 
		tag "tr" do
			context.randomList.each do |note|
				tag "td" do
					text note.to_s
				end
			end
		end
	end
end

context = OpenStruct.new notes: notes
__result = ''

Benchmark.bmbm(20) do |bcmk|
  bcmk.report("erb_test") { (1..2000).each { ERB.new(erb_example, trim_mode: 0).result binding } }
  bcmk.report("slim_test") { (1..2000).each{ Slim::Template.new { slim_example }.render(context) } }
  bcmk.report("my_new_test") { (1..2000).each { 
		engine.run "notes" do
			param :notes, context.notes
		end
	} 
  }
end
