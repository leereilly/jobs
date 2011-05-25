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
  markdown << "<table>"
  github_jobs.each do |job|
  markdown << "<tr><td>#{job['company']}</td><td>#{job['title']}</td></tr>\n"
  end
  markdown << "/<table>"
  return markdown
end

File.open('README.md', 'w') {|f| f.write(generate_readme) }