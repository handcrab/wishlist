module Helpers
  # require ActionView::Base
  include ActionView::Helpers
  include ApplicationHelper

  # ??? undefined method `white_list_sanitizer'
  include ActionView::Helpers::TextHelper

  def sanitized_md txt
    ActionView::Base.full_sanitizer.sanitize markdown txt
  end
end
World(Helpers)