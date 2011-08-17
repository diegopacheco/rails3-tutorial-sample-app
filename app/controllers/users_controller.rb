require 'will_paginate'
require 'exceptions'

class UsersController < ApplicationController
  
  before_filter :authenticate, :only =>[:index, :edit, :update, :destroy]
  before_filter :correct_user, :only =>[:edit, :update]
  before_filter :admin_user,   :only => :destroy 

  def new
    redirect_to_root_if_already_signedin
    @user  = User.new
    @title = "Sign up"    
  end

  def show
    @user  = User.find(params[:id])  
    @title = @user.name
  end

  def create    
     redirect_to_root_if_already_signedin  
     @user = User.new(params[:user])
     if @user.save 
        sign_in @user
        flash[:success] = "Welcome to the Sample App!" 
        redirect_to @user
     else
        @title = "Sign up"
        @user.reset_password
        render 'new'  
     end    
  end 

  def edit
      @user  = User.find(params[:id])
      @title = "Edit user"
  end

  def update
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
          flash[:success] = "Profile updated."
          redirect_to@user
      else
          @title = "Edit user"
          render 'edit'
      end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def destroy
     dont_let_the_user_delete_himself
     User.find(params[:id]).destroy
     flash[:sucess] = "User destroy"  
     redirect_to users_path 
  end

  private
  
  def authenticate
      deny_access unless signed_in?
  end

  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
  end

  def store_location
      session[:return_to] = request.fullpath
  end
  
  def clear_return_to
      session[:return_to] = nil
  end

  def admin_user
      redirect_to(root_path) unless current_user.admin?  
  end

  def redirect_to_root_if_already_signedin
      redirect_to(root_path) unless !signed_in?
  end  

  def dont_let_the_user_delete_himself
     #puts "current_user_id = #{current_user.id}" 
     #puts "params_id = #{params[:id].id}" 
     if current_user.id == params[:id].id  
       raise Exceptions::Unable_To_Delete_Yourself_Youre_Not_a_EMO 
     end
  end 

end
