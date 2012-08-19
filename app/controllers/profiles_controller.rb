class ProfilesController < ApplicationController
   before_filter :authenticate_user!
  
  def show
    @user = User.find(params[:user_id])
    @orofile = Profile.find(:first, :conditions => ['user_id = ?', params[:user_id]])

      respond_to do |format|
        format.html {redirect_to user_path(@user) }
      end
  end

  def new
    @user = User.find(params[:user_id])
    @profile = @user.build_profile


    if (authenticate_owner || authenticate_admin)
      return [@user, @profile]
    else respond_to do |format|
          format.html { redirect_to user_path(@user), alert: 'You are not authorized to create this profile.' }
          format.json { head :no_content }
      end
    end

  end
    
  def edit
    @user = User.find(params[:user_id])
    @profile = Profile.find(:first, :conditions => ['user_id = ?', params[:user_id]])
    
    if (authenticate_owner || authenticate_admin)
      return [@user, @profile]
    else respond_to do |format|
          format.html { redirect_to user_path(@user), alert: 'You are not authorized to edit this profile.' }
          format.json { head :no_content }
      end
    end

  end

  def update
    @user = User.find(params[:user_id])
    @profile = Profile.find(:first, :conditions => ['user_id = ?', params[:user_id]])


    if (authenticate_owner || authenticate_admin)
      if @profile.update_attributes(params[:profile]) 
        redirect_to user_path(@user)
      end
    else respond_to do |format|
          format.html { redirect_to user_path(@user), alert: 'You are not authorized to edit this profile.' }
          format.json { head :no_content }
      end
    end

    
  end

  def create 
    @user = User.find(params[:user_id])
    @profiles = @user.build_profile(params[:profile])
    # @profiles = Profile.new(params[:profiles])

    if (authenticate_owner || authenticate_admin)
      if @profiles.save
        redirect_to user_path(@user)
      end
    else respond_to do |format|
          format.html { redirect_to user_profile_path(@user), alert: 'You are not authorized to create this profile.' }
          format.json { head :no_content }
      end
    end

    # respond_to do |format|
    #   if @profiles.save
    #     format.html { redirect_to @user, notice: 'Profile was successfully created.' }
    #     format.json { render json: @user, status: :created, location: @user }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @profiles.errors, status: :unprocessable_entity}
    #   end
    # end
  end

  def download_resume
      @profile = Profile.find(:first, :conditions => ['user_id = ?', params[:id]])
      send_file @profile.resume.path, :type => 'application/pdf', :disposition => 'inline'
  end


  def authenticate_owner
    if current_user.present?
      if current_user.id == @user.id
        true
      else
        false
      end
    else
      false
    end
  end

  def authenticate_admin
    if current_user.present?
      if current_user.admin?
        true
      else
        false
      end
    else
      false
    end
  end

end

