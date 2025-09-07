# app/controllers/follows_controller.rb
class FollowsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user
  
    def create
      current_user.follow(@user)
      redirect_back fallback_location: @user, notice: "フォローしました"
    rescue ActiveRecord::RecordInvalid => e
      redirect_back fallback_location: @user, alert: e.record.errors.full_messages.to_sentence
    end
  
    def destroy
      current_user.unfollow(@user)
      redirect_back fallback_location: @user, notice: "フォローを解除しました"
    end
  
    private
    def set_user
      @user = User.find(params[:user_id])  # ← ビューから user_id を受け取る前提
    end
  end
  