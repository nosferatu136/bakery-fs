class CookieBakerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(cookie_id)
    cookie = Cookie.find_by(id: cookie_id)
    cookie.update_attributes!(ready: true) if cookie && !cookie.ready?
  end
end
