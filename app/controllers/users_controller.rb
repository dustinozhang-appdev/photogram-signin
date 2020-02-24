class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })
    @justsignedin = params["justsignedin"]
    @justsignedout = params["justsignedout"]
    render({ :template => "users/index.html" })
  end

  def sign_in
    @nouser = params["nouser"]
    @wrongpassword = params["wrongpassword"]
    render({ :template => "users/signin.html.erb" })
  end

  def sign_out
    session[:current_user_id] = nil
    redirect_to("/?justsignedout=1")
  end

  def sign_up
    @blankuser = params["blankuser"]
    @blankpassword = params["blankpassword"]
    @nonmatching = params["nonmatching"]
    @existingalready = params["existingalready"]
    render({ :template => "users/signup.html.erb" })
  end

  def verify_credentials
    u = User.where(:username => params["input_username"])[0]
    if (u == nil) 
      redirect_to("/user_sign_in?nouser=1")
      return
    end
    if (u.password != params["input_password"])
      redirect_to("/user_sign_in?wrongpassword=1")
      return
    end

    session[:current_user_id] = u.id
    redirect_to("/?justsignedin=1")
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)
    @justcreated = params["justcreated"]

    render({ :template => "users/show.html.erb" })
  end

  def create
    if (params["input_username"] == "") 
      redirect_to("/user_sign_up?blankuser=1")
      return
    elsif (params["input_password"] == "")
      redirect_to("/user_sign_up?blankpassword=1")
      return
    elsif (params["input_password"] != params["input_password_confirmation"])
      redirect_to("/user_sign_up?nonmatching=1")
      return
    elsif (User.where(:username => params["input_username"])[0] != nil)
      redirect_to("/user_sign_up?existingalready=1")
      return
    end

    user = User.new

    user.username = params["input_username"]
    user.password = params["input_password"]

    user.save

    user = User.where(:username => params["input_username"])[0]
    session[:current_user_id] = user.id

    redirect_to("/users/#{user.username}?justcreated=1")
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

end
