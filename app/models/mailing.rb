class Mailing < ActiveRecord::Base
  attr_accessible :subject, :body, :sent_mails, :all_mails, :published

  #размер боксов полей в форме
  BODY_COLS_SIZE = 60
  BODY_ROWS_SIZE = 20
  
  def update_published_at
    self.published_at = Time.now if published == true
  end
  
end
