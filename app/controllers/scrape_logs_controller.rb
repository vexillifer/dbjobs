class ScrapeLogsController < ApplicationController

	require 'open-uri'

	def index
		# get most recent scrape log entry
		@scrape_log = ScrapeLog.find(:first, :order => "dbworld_date DESC, created_at ASC")
		if @scrape_log.nil?
			@scrape_post = nil
		else 
			@scrape_post = Post.find(@scrape_log.post_id)
		end

		@scrape_date_urls = ScrapeLog.where("dbworld_date >= ?", @scrape_log.dbworld_date)
	end

	def scrape

		url = 'http://research.cs.wisc.edu/dbworld/browse.html'
		@doc = Nokogiri::HTML(open(url))


		# get most recent scrape log entry
		@scrape_log = ScrapeLog.find(:first, :order => "dbworld_date DESC, created_at ASC")
		if @scrape_log.nil?
			@scrape_post = nil
			x_scrape = DateTime.now
			y_scrape = DateTime.new(x_scrape.year, x_scrape.month, x_scrape.day)
			scrape_date = y_scrape - 6.months
			scrape_url = ""
		else 
			@scrape_post = Post.find(@scrape_log.post_id)
			scrape_date = @scrape_log.dbworld_date
			scrape_url = @scrape_log.dbworld_link
		end

		@scrape_date_urls = ScrapeLog.where("dbworld_date >= ?", @scrape_log.dbworld_date)

		@doc.css("tbody").each do |item| 
			item.css("tr").each do |tr|
				date = Date.parse(tr.at_css("td").text) unless item.at_css("td").nil?


				if date >= scrape_date - 1.day
					type = tr.at_css("td").next_element.text unless item.at_css("td").next_element.nil?
					if type.include? 'job ann.'
						title = tr.at_css("td").next_element.next_element.next_element.text unless item.at_css("td").next_element.next_element.next_element.nil?

						# Get description text
						l = tr.css('td a').map { |link| link['href'] }
						@description_doc = Nokogiri::HTML(open(l.first), 'utf-8')
						description = @description_doc.css("pre").text
						description = description + "\n Web Page: " + l.second unless l.second.nil?

						# Return when it hits one of the posts posted on scrape_date
						@scrape_date_urls.each do |url|
							if l.first.eql?("#{url.dbworld_link}")
								respond_to do |format|
									format.html {redirect_to scrape_logs_path, :notice => 'Scrapes up-to-date'}
								end
								return
							end
						end

						# Set deadline if there is one
						if item.at_css("td").next_element.next_element.next_element.next_element.nil?
							deadline = (Time.now + 6.month).strftime("%Y-%m-%d")
						else
							deadline = Date.parse(tr.at_css("td").next_element.next_element.next_element.next_element.text)
						end

						# Parse emails 
						email = description.scan(/\b[A-Z0-9._%a-z-]+@(?:[A-Z0-9a-z-]+\.)+[A-Za-z]{2,6}\b/i)

						# Create post and user account if applicable 
						if email.first.nil?
							@user = User.find(1)
							@new_post = Post.new(:title => title, :expiry => deadline, :description => description, :status => 1, :poster_id => @user.id, :created_at => date)
							@new_post.save
						else
							# check user does not already exist
							@user = User.where("lower(email) = lower(?)", "#{email.first}").first
							if @user.nil?
								@user = User.new
							end

							# Create reset password token 
							@user.password = User.reset_password_token #won't actually be used...  
							@user.reset_password_token = User.reset_password_token 
							@user.reset_password_sent_at = Time.now
							@user.email = "#{email.first}" 
							@user.save

							@new_post = Post.new(:title => title, :expiry => deadline, :description => description, :status => 1, :poster_id => @user.id, :created_at => date)
							@new_post.save
							# Email user 
							# TODO only email if user does not have an account
							UserMailer.scrape_post_owner(@user, @new_post).deliver

						end

						@new_scrape = ScrapeLog.new(:user_id => @user.id, :post_id => @new_post.id, :dbworld_date => date, :dbworld_link => l.first)
						@new_scrape.save
					end

				else
					respond_to do |format|
						format.html {redirect_to scrape_logs_path, :notice => 'Scrapes up-to-date'}
					end
					return
				end
			end
		end 
		respond_to do |format|
			format.html {redirect_to scrape_logs_path, :notice => 'Scrapes up-to-date'}
		end
	end
end