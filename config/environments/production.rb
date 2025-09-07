require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"] or config/master.key.
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local
  # 本番で S3 を使うなら:
  # config.active_storage.service = :amazon

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # 本番で HTTPS 強制したい場合は有効化
  # config.force_ssl = true

  # Include generic and useful information about system operation, but avoid logging too much PII.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "hobbyverse_production"

  # ---------------------------
  # Action Mailer (本番メール設定)
  # ---------------------------
  config.action_mailer.perform_caching = false

  # メール本文内のURL生成に使うホスト/プロトコル
  config.action_mailer.default_url_options = {
    host: ENV.fetch("APP_HOST", "example.com"), # 例: app.hobbyverse.com
    protocol: "https"
  }
  # メール内で画像/CSS等の絶対URLを使う場合
  config.action_mailer.asset_host = "https://#{ENV.fetch('APP_HOST', 'example.com')}"

  # SMTP で送信
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  # SMTP サーバ設定（SendGrid 想定。自前のSMTPに置き換え可）
  config.action_mailer.smtp_settings = {
    address:              ENV.fetch("SMTP_ADDRESS", "smtp.sendgrid.net"),
    port:                 ENV.fetch("SMTP_PORT", "587").to_i,
    domain:               ENV.fetch("SMTP_DOMAIN", ENV.fetch("APP_HOST", "example.com")),
    user_name:            ENV.fetch("SMTP_USERNAME", "apikey"),          # SendGridは 'apikey' 固定
    password:             ENV.fetch("SMTP_PASSWORD") { ENV["SENDGRID_API_KEY"] }, # どちらかに設定
    authentication:       :plain,
    enable_starttls_auto: true
  }

  # Enable locale fallbacks for I18n
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Log disallowed deprecations.
  config.active_support.disallowed_deprecation = :log

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Inserts middleware to perform automatic connection switching.
  # config.active_record.database_selector = { delay: 2.seconds }
  # config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
  # config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session
end
