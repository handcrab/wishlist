module ApplicationHelper
  def owned_wishes_page?
    current_page? owned_wishes_path
  end
  def all_wishes_page?
    current_page? all_wishes_path
  end
  
  def formatted_date date
    l date, format: :short
  end

  def markdown text
    opts = { 
      autolink: true, 
      space_after_headers: true, 
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      highlight: true,
      strikethrough: true
    }
    # markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    @markdown ||= Redcarpet::Markdown.new Redcarpet::Render::HTML, opts
    @markdown.render text || ''
  end

  # def markdown text
  #   GitHub::Markdown.render_gfm text    
  # end

  def simple_markdown text
    simple_format markdown text
  end
end
