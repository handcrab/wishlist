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

  def avatar_url user, style=:medium
    if user.avatar.present?
      user.avatar.url style
    else
      # show gravatar img
      # default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5.hexdigest user.email.downcase
      sizes = {medium: 100, thumb: 25}; sizes.default = 100
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{sizes[style]}" #&d=#{CGI.escape(default_url)}"
    end
  end
end
