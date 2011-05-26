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
  job_id = 0
  markdown = "# JOBS\n"
  github_jobs = get_github_jobs  
  markdown << "<table>"
  github_jobs.each do |job|
    job_id = job_id + 1
    markdown << "<tr><td>**<a title='Go to #{job['company']} homepage' href='#{job['company_url']}'>#{job['company']}</a>**</td><td><a id='#{job_id}' title='#{job['description'].gsub(/<\/?[^>]*>/, "")}' href='#{job['url']}'>#{job['title']}</a></td></tr>\n"
  end
  markdown << "<table>"
  return markdown
end

File.open('README.md', 'w') {|f| f.write(generate_readme) }