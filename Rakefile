require "bundler/gem_tasks"
require 'rake/clean'
require 'rake/testtask'

CLEAN.include('ext/getdns/*{.o,.log,.so,.bundle}')
CLEAN.include('ext/getdns/Makefile',"pkg")
CLOBBER.include('lib/*{.so,.o,.bundle}')


desc 'Build the getdns C extension'
task :build_ext do
  Dir.chdir("ext/getdns") do
    ruby "extconf.rb"
    sh "make"
  end
  cp "ext/getdns/getdns.bundle", "lib/"
end

Rake::TestTask.new do |t|
  t.pattern = 'test/*.rb'
end

