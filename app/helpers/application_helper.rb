module ApplicationHelper
  def render_turbo_flash
    turbo_stream.prepend 'flash', partial: 'layouts/flash'
  end
end
