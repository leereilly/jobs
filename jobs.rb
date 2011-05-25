#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'
require 'json'

KEYWORDS = ""
LOCATION = "san+francisco"

BASE_GITHUB_URL = "http://jobs.github.com/positions.json?description=#{KEYWORDS}&location=#{LOCATION}"

def get_github_jobs()
  response = Net::HTTP.get_response(URI.parse(BASE_GITHUB_URL))
  if response.code == '200'
    return JSON.parse(response.body)
  else
    raise "Problem pinging #{BASE_GITHUB_URL}"
  end
end

def generate_readme
  markdown = "= JOBS\n"
  github_jobs = get_github_jobs  
  github_jobs.each do |job|
  markdown << "#{job['company']} | #{job['title']}\n"
  end
  return markdown
end

File.open('README', 'w') {|f| f.write(generate_readme) }