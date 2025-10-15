class AlertsController < ApplicationController
  before_action :set_alert, only: %i[ show edit update destroy toggle ]

  def index
    @alerts = Alert.order(created_at: :desc)
  end

  def show; end

  def new
    @alert = Alert.new
  end

  def edit; end

  def create
    @alert = Alert.new(alert_params)
    if @alert.save
      redirect_to alerts_path, notice: "Alert created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @alert.update(alert_params)
      redirect_to alerts_path, notice: "Alert updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @alert.destroy
    redirect_to alerts_path, notice: "Alert deleted"
  end

  def toggle
    @alert.update(active: !@alert.active)
    redirect_to alerts_path, notice: "Alert #{@alert.active ? 'activated' : 'paused'}"
  end

  private

  def set_alert
    @alert = Alert.find(params[:id])
  end

  def alert_params
    params.require(:alert).permit(:symbol, :threshold, :direction, :active, notification_channel_ids: [])
  end
end
