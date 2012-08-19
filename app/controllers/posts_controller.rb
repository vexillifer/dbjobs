class PostsController < ApplicationController

  

 def map
  @json = Address.location_search(params).to_gmaps4rails 
end


def download_post_info
  @post = Post.find(params[:id])
  send_file @post.info.path, :type => 'application/pdf', :disposition => 'inline'
end

def review
  if authenticate_admin
    @posts = Post.order('created_at DESC').where("status = 0")
  else
    respond_to do |format|
      format.html { redirect_to posts_url, alert: 'You are not authorized to review posts.' }
      format.json { head :no_content }
    end
  end
end


def owned
  @posts = Post.order('created_at DESC').where("poster_id = #{current_user.id}")
end

def favourite
  @post = Post.find(params[:post_id])
  @favourite = Favourite.new do |f|
    f.post_id = params[:post_id]
    f.user_id = params[:user_id]
  end
  respond_to do |format|
    if @favourite.save
      format.html{ redirect_to @post, notice: 'Post added to favourites.'}
    else
     format.html{ redirect_to @post, notice: 'Post is already a favourite.'}
  end
end

def unfavourite
  Favourite.delete_all "user_id = #{current_user.id}"

  respond_to do |format|
      format.html{ redirect_to posts_favourites_path, notice: 'Posts removed from favourites.'}
  end
end

end

def favourites
  @user_favourites = Favourite.where("user_id = #{current_user.id}")
  @posts = Post.order('created_at DESC').joins(:favourites).where("user_id = #{current_user.id}")
end

  def diff
    @posts = Post.where("created_at >= ?", Time.now - 14.days)

    @diff = {}

    @posts.each do |p1|
      @posts.each do |p2|
        unless p1.id == p2.id
          white = Text::WhiteSimilarity.new
          score = white.similarity(p1.description , p2.description)
          if score >= 0.8
            # Avoid duplicates, add to diff hash
            if p2.id > p1.id
              hid = "#{p1.id}_#{p2.id}"
            else 
              hid = "#{p2.id}_#{p1.id}"
            end 
            @diff[hid] = {score: score, p2: p2.id, p1: p1.id}
          end
        end
      end
    end
  end

def index

  @addresses = Address.location_search(params)

  # Cannot have address details for RSS feed
  unless params[:format] == 'rss'
  # Populate gmaps info windows
  if @addresses.nil?
    @json = Address.all.to_gmaps4rails do |address, marker|
      @post = Post.where("address_id = ?", "#{address.id}").first
      marker.infowindow render_to_string(:partial => "infowindow", :locals => { :post => @post })
    end
  else
    @json = @addresses.to_gmaps4rails do |address, marker|
      @post = Post.where("address_id = ?", "#{address.id}").first
      marker.infowindow render_to_string(:partial => "infowindow", :locals => { :post => @post })
    end
  end
end

  # Find user job preference if one exists
  if current_user.present?
    @job_pref = JobPreference.where("user_id = ?", current_user.id).first
  else
    @job_pref = nil
  end

  @posts = Post.search(params, @addresses)
  @posts = @posts.paginate(:page => params[:page], :per_page => 20, :total_entries => @posts.count)

end  


  # GET /posts/1                                                         
  # GET /posts/1.json                                                     
  def show
    @post = Post.find_by_id(params[:id]) 

    unless @post
    # If post does not exist, check for redirect
      @redirection = Redirection.where(:from_post => params[:id]).first
      @post = Post.find(@redirection.to_post) 

      params[:id] = @redirection.to_post
    end


    @markdown = BlueCloth.new(@post.description).to_html.html_safe
    if current_user.present?
      @favourite = Favourite.find(:first, :conditions => {:user_id => current_user.id, :post_id => @post.id})
    else
      @favourite = nil
    end
    # If the post is not in active state, do not show to general public
    if @post.status != 1 && !(authenticate_admin || authenticate_owner)
      respond_to do |format|
      format.html { redirect_to posts_url, alert: 'This post is not active.' }
      format.json { head :no_content }
    end
    elsif
      respond_to do |format|
        format.html # show.html.erb                                        
        format.json { render json: @post}
      end
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new     
    if current_user.present?                                                                 
      @post = Post.new  
      @address = @post.build_address                                                     

      respond_to do |format|
        format.html # new.html.erb
        # If current user is not an approved poster, notify them of pending state
        if current_user.approved_poster?
          format.json { render json: @post }
        else 
          format.json { render json: @post, notice: "Your post is pending approval. You will receive an email as soon as your job posting has been accepted. You can review the status of all your job postings under 'Your Posts'." }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: 'You must log in to create a post.' }
        format.json { head :no_content }
      end
    end
  end 

  # GET /posts/1/edit                                                          
  def edit
    @post = Post.find(params[:id])
    if @post.address_id.nil?
      @address = @post.build_address 
    else
      @address = Address.where(@post.address_id)
    end

    # @address = @post.build_address
    # TODO find address, don't build it
    if (authenticate_owner || authenticate_admin)
      return @post
    else
      respond_to do |format|
        format.html { redirect_to posts_url, alert: 'You are not authorized to update this post.' }
        format.json { head :no_content }
      end
    end
  end

    # POST /posts                                                                 
  # POST /posts.json                                                            
  def create
    # Allows for the partial form under address fields_for (one-to-many relationship issue)


    # Make current user poster
    params[:post][:poster_id] = current_user.id

    if current_user.approved_poster?
      params[:post][:status] = 1
    end

    newHash = params
    if params[:address]
      newHash[:post][:address_attributes]['state_code'] = params[:address].fetch('state_code')
      @post = Post.new(newHash[:post])
    else 
      @post = Post.new(params[:post])
    end



    respond_to do |format|
      if @post.save

        if current_user.approved_poster?
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
        else 
          format.html { redirect_to @post, notice: "Your post is pending approval. You will receive an email as soon as your job posting has been accepted. You can review the status of all your job postings under 'Your Posts'." }
        end
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity}
      end
    end
  end

# PUT /posts/1                                                                
  # PUT /posts/1.json                                                           
  def update
    @post = Post.find(params[:id])


    # Post rejected if reason was found
    if !params[:text].nil? && params[:text] != ''
      @post = Post.find(params[:id])
      @user = User.find(@post.poster_id)
      @text = params[:text]

      if authenticate_admin
      respond_to do |format|
        if @post.update_attributes(:status => 3)

          UserMailer.post_rejection_email(@user, @post, @text).deliver
          format.html { redirect_to @post, notice: 'Post was rejected.' }        
          format.json { head :no_content }
        else
          format.html { render action: "show" }
          format.json { render json: @post.errors, status: :unprocessable_entity}
        end
      end
      else respond_to do |format|
          format.html { redirect_to @post, alert: 'You are not authorized to reject this post.' }        
          format.json { head :no_content }
        end
      end
    elsif (authenticate_owner || authenticate_admin)



      # Admin or Owner can resubmit
      if params[:commit].eql?('Re-Submit')
        params[:post][:status] = 0

        # Post is pending approval again
        respond_to do |format|
          if @post.update_attributes(params[:post])
            format.html { redirect_to @post, notice: "Your post is pending approval. You will receive an email as soon as your job posting has been accepted. You can review the status of all your job postings under 'Your Posts'." }        
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @post.errors, status: :unprocessable_entity}
          end
        end

      # Only admin can approve
      elsif params[:commit].eql?('Approve') && authenticate_admin
        params[:post][:status] = 1


        # Approved post, make user approved poster as well
        @user = User.find(@post.poster_id)
        # Mail user that their post is approved
        UserMailer.post_approval_email(@user, @post).deliver
        unless @user.approved_poster?
          @user.update_attribute :approved_poster, true
        end

        respond_to do |format|
          if @post.update_attributes(params[:post])
            format.html { redirect_to @post, notice: 'Post status was successfully updated.' }        
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @post.errors, status: :unprocessable_entity}
          end
        end


      # Set status to one automatically
      elsif current_user.approved_poster
        params[:post][:status] = 1
        respond_to do |format|
            if @post.update_attributes(params[:post])
              format.html { redirect_to @post, notice: 'Post was successfully updated.' }        
              format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @post.errors, status: :unprocessable_entity}
            end
          end
      # No authorized to change post status
      elsif params[:post][:status]
        respond_to do |format|
          format.html { redirect_to posts_url, alert: 'You are not authorized to change the post status.' }
          format.json { head :no_content }
        end
        # Otherwise regular user updating post
      else 
         respond_to do |format|
            if @post.update_attributes(params[:post])
              format.html { redirect_to @post, notice: 'Post was successfully updated.' }        
              format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @post.errors, status: :unprocessable_entity}
            end
          end
      end
      # User not allowed to edit post 
    else 
      respond_to do |format|
          format.html { redirect_to posts_url, alert: 'You are not authorized to update this post.' }
          format.json { head :no_content }
        end
      end
end


  # DELETE /posts/1                                                      
  # DELETE /posts/1.json                                                 
  def destroy
    @post = Post.find(params[:id])
    if (authenticate_owner || authenticate_admin)
      @post.destroy

      respond_to do |format|
        format.html { redirect_to posts_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_url, alert: 'You are not authorized to delete this post.' }
        format.json { head :no_content }
      end
    end
  end


  def search_job_pref
    # Find user job preference if one exists
    if current_user.present?
      @job_pref = JobPreference.where("user_id = ?", current_user.id).first
    else
      @job_pref = nil
    end

    # Add job preference details to search params
    params[:addr] = @job_pref.address unless @job_pref.address.nil? 
    params[:edu] = @job_pref.education_level unless @job_pref.education_level.nil?

    respond_to do |format|
      format.html { redirect_to params.merge! :action => 'index'}
      format.xml  { render :xml => @job_pref }
      format.json { render :json => @job_pref}
    end
  end


  def authenticate_owner
    if current_user.present?
      if current_user.id == @post.poster_id
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

