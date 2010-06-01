# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "Beta.archety.pe"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def display_standard_flashes(message = 'There were some problems with your submission:')
    if flash[:notice]
      flash_to_display, level = flash[:notice], 'msg msg-ok'
    elsif flash[:warning]
      flash_to_display, level = flash[:warning], 'msg msg-warn'
    elsif flash[:error]
      level = 'msg msg-error'
      if flash[:error].instance_of?( ActiveRecord::Errors) || flash[:error].is_a?( Hash)
        flash_to_display = message
        flash_to_display << activerecord_error_list(flash[:error])
      else
        flash_to_display = flash[:error]
      end
    else
      return
    end
    #content_tag 'div', flash_to_display, :class => "flash#{level}"
     content_tag 'div', flash_to_display, :class => "#{level}"
  end

  def activerecord_error_list(errors)
    error_list = '<ul class="error_list">'
    error_list << errors.collect do |e, m|
      "<li>#{e.humanize unless e == "base"} #{m}</li>"
    end.to_s << '</ul>'
    error_list
  end



end
