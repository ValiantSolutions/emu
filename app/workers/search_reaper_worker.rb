class SearchReaperWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(id, *args)
    s = Search.find_by_id(id)
    return if s.nil?
    s.destroy!
  end
end