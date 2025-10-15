Rails.application.config.after_initialize do
  Thread.new do
    loop do
      begin
        CheckPricesJob.perform_later
      rescue => e
        Rails.logger.error("Scheduler error: #{e.message}")
      ensure
        sleep 30
      end
    end
  end
end
