class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  default :from => "db-jobs@cs.ubc.ca"

  def post_approval_email(user, post)
    @user = user
    @post = post
    @url = "http://www.dbjobs.org/posts/#{post.id}"
    mail(:to => @user.email, :subject => "Job Posting Approval")
  end

  def post_rejection_email(user, post, text)
    @user = user
    @post = post
    @text = text
    @url = "http://www.dbjobs.org/posts/#{post.id}"
    mail(:to => @user.email, :subject => "Job Posting Rejection")
  end

  def scrape_post_owner(user, post)
    @user = user
    @post = post
    @post_url = "http://www.dbjobs.org/posts/#{post.id}"
    @activation = "http://www.dbjobs.org/users/password/edit?initial=true&reset_password_token=#{@user.reset_password_token}"
    # Add user activation link
    mail(:to => @user.email, :subject => "DBWorld Job Posting is now available on dbjobs")
  end



# Devise mail rerouted through this mailer
  def confirmation_instructions(record)
    devise_mail(record, :confirmation_instructions)
  end

  def reset_password_instructions(record)
    devise_mail(record, :reset_password_instructions)
  end

  def unlock_instructions(record)
    devise_mail(record, :unlock_instructions)
  end
end
