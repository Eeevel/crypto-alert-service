class NotificationMailer < ApplicationMailer
  def alert_crossed
    @alert = params[:alert]
    @current_price = params[:current_price]
    mail(to: params[:to], subject: "Crypto Alert: #{@alert.symbol} crossed #{@alert.threshold}")
  end
end
