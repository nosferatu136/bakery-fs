class CookieBakerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(cookie_id)
    cookie = Cookie.find_by(id: cookie_id)
    if cookie && !cookie.ready?
      cookie.update_attributes!(ready: true)
    end
  end
end