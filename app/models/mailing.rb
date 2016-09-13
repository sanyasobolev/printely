class Mailing < ActiveRecord::Base
  #размер боксов полей в форме
  BODY_COLS_SIZE = 60
  BODY_ROWS_SIZE = 20
  
  default_scope { order(created_at: :desc)}
  
  def update_published_at
    self.published_at = Time.now if published == true
  end
  
end
