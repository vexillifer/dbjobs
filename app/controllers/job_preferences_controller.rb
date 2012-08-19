class JobPreferencesController < ApplicationController
   before_filter :authenticate_user!
  
  def show
    @user = User.find(params[:user_id])
    @job_pref = JobPreference.find(:first, :conditions => ['user_id = ?', params[:user_id]])
  
    if (authenticate_owner || authenticate_admin)
      return [@user, @job_pref]
    else respond_to do |format|
          format.html { redirect_to user_path(@user) }
          format.json { head :no_content }
      end
    end

  end

  def new
    @user = User.find(params[:user_id])
    @job_pref = @user.build_job_preference

    if (authenticate_owner || authenticate_admin)
      return [@user, @job_pref]
    else respond_to do |format|
          format.html { redirect_to user_path(@user), alert: 'You are not authorized to create this job preference.' }
          format.json { head :no_content }
      end
    end
  end
    
  def edit
    @user = User.find(params[:user_id])
    @job_pref = JobPreference.find(:first, :conditions => ['user_id = ?', params[:user_id]])  
  
    if (authenticate_owner || authenticate_admin)
      return [@user, @job_pref]
    else respond_to do |format|
          format.html { redirect_to user_path(@user), alert: 'You are not authorized to edit this job preference.' }
          format.json { head :no_content }
      end
    end
  end

  def update
    @user = User.find(params[:user_id])
    @job_pref = JobPreference.find(:first, :conditions => ['user_id = ?', params[:user_id]])

    
    if (authenticate_owner || authenticate_admin)
      respond_to do |format|
      if @job_pref.update_attributes(params[:job_preference])
        format.html { redirect_to user_job_preference_path(@user), notice: 'Job Preference was successfully updated.' }
        format.json { head :no_content }
      end
    end
    else respond_to do |format|
          format.html { redirect_to user_path(@user), alert: 'You are not authorized to update this job preference.' }
          format.json { head :no_content }
      end
    end
  end

  def create 
    @user = User.find(params[:user_id])
    @job_pref = @user.build_job_preference(params[:job_preference])
    # @profiles = Profile.new(params[:profiles])


    if (authenticate_owner || authenticate_admin)
      respond_to do |format|
      if @job_pref.save
        format.html { redirect_to user_job_preference_path(@user), notice: 'Job Preference was successfully created.' }
        format.json { head :no_content }
      end
    end
    else respond_to do |format|
          format.html { redirect_to user_path(@user), alert: 'You are not authorized to edit this job preference.' }
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

