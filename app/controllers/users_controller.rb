class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @users = User.search(params)
    @users = @users.paginate(:page => params[:page], :per_page => 20, :total_entries => @users.count)
  end

  def show
    @user = User.find(params[:id])
	  @profiles = Profile.find(:first, :conditions => ['user_id = ?', params[:id]])
    @job_pref = JobPreference.find(:first, :conditions => ['user_id = ?', params[:id]])



    @markdown = @markdown = BlueCloth.new(@profiles.bio).to_html.html_safe
    unless @profiles.nil? || @profiles.linkedin.nil?
      linkedin_str = @profiles.linkedin
      @linkedin = ActiveSupport::JSON.decode(linkedin_str)
    else
      @linkedin = nil
    end


  end

  def linkedin
    # get your api keys at https://www.linkedin.com/secure/developer
    client = LinkedIn::Client.new('r24w3z5x81sc', 'GuA1OLqKfkpLGqrz')
    request_token = client.request_token(:oauth_callback => 
                                      "http://#{request.host_with_port}/users/#{current_user.id}/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to client.request_token.authorize_url
  end


  def callback
    client = LinkedIn::Client.new('r24w3z5x81sc', 'GuA1OLqKfkpLGqrz')
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end

    @profile = Profile.where("user_id = ?", current_user.id).first
    if @profile.nil?
      respond_to do |format|
        format.html {redirect_to user_path(User.find(current_user.id)), alert: "You must have a profile to integrate with LinkedIn."}
      end
    else

      # Create hash of linkedin profile
      @linkedin = {positions: {}, educations: {}, publications: {}}

      @linkedin_profile = client.profile( 
        :fields => [:educations, :positions, :publications])


      @linkedin_profile.positions.all.each do |aposition|
        position = aposition.to_hash
        
        @linkedin[:positions][position["id"]] = 
          {title: position["title"], current: position["is_current"], start_month:
          User.month(position["start_date"]["month"].to_i), start_year: position["start_date"]["year"], 
          summary: position["summary"], company: position["company"]["name"]}

        if position["is_current"]
        else
          @linkedin[:positions][position["id"]].merge!( {
          end_month: User.month(position["end_date"]["month"].to_i), end_year: position["end_date"]["year"]})
        end
      end


      @linkedin_profile.educations.all.each do |aeducation|
        education = aeducation.to_hash
        @linkedin[:educations][education["id"]] = {school: education["school_name"], degree: education["degree"], 
          field: education["field_of_study"], start_year: education["start_date"]["year"], end_year: education["end_date"]["year"], 
          activities: education["activities"]}
      end
      
      unless @profile.linkedin.nil?
        @profile.linkedin = ""
        @profile.save
      end

      @profile.linkedin = @linkedin.to_json
      @profile.save

      respond_to do |format| 
        format.html { redirect_to user_path(User.find(current_user.id)), notice: "LinkedIn integration successfully completed."}
      end
    end
  end

  

end





# class LinkedIn::Position
#   def gsub!(pattern, replacement)
#     each { |x|
#       x.gsub!(pattern, replacement)
#       }
#   end
# end