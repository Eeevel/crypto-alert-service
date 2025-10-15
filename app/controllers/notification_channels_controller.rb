class NotificationChannelsController < ApplicationController
  before_action :set_channel, only: %i[ show edit update destroy ]

  def index
    @notification_channels = NotificationChannel.order(:name)
  end

  def show; end

  def new
    @notification_channel = NotificationChannel.new
  end

  def edit; end

  def create
    @notification_channel = NotificationChannel.new(channel_params)
    if @notification_channel.save
      redirect_to notification_channels_path, notice: "Channel created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @notification_channel.update(channel_params)
      redirect_to notification_channels_path, notice: "Channel updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @notification_channel.destroy
    redirect_to notification_channels_path, notice: "Channel deleted"
  end

  private

  def set_channel
    @notification_channel = NotificationChannel.find(params[:id])
  end

  def channel_params
    params.require(:notification_channel).permit(:name, :kind, :settings)
  end
end
