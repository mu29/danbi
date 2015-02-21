# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/superators.rb'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |opts|
  opts.spec_opts = %w'-c'
end

desc "Generate a HTML report of the RSpec specs"
Spec::Rake::SpecTask.new "report" do |opts|
  opts.spec_opts = %w'--format html:report.html'
end

Hoe.new('superators', Superators::VERSION) do |p|
  p.rubyforge_name = 'superators'
  p.author = 'Jay Phillips'
  p.email = 'jay -at- codemecca.com'
  p.summary = 'Superators add new sexy operators to your Ruby objects.'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

# vim: syntax=Ruby
