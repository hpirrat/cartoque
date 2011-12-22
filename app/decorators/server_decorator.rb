class ServerDecorator < ResourceDecorator
  decorates :server

  def virtual_badge
    blank_unless model.virtual? do
      h.content_tag(:div, "V", :class => "contextual virtual-server")
    end
  end

  def puppet_badge
    blank_unless model.puppetversion.present? do
      h.content_tag(:div, "P", :class => "contextual has-puppet")
    end
  end

  def network_device_badge
    blank_unless model.network_device? do
      h.content_tag(:div, h.image_tag("router.png", :title => t(:network_device), :size => "16x16"),
                    :class => "contextual network-device")
    end
  end

  def badges
    virtual_badge + puppet_badge + network_device_badge
  end

  def blank_unless(condition)
    (condition ? yield : "").html_safe
  end

  def cores
    html = ""
    html << "#{model.nb_proc} * " unless model.nb_proc == 1
    html << "#{model.nb_coeur} cores, " unless model.nb_coeur.blank? || model.nb_coeur <= 1
    html << "#{model.frequency} GHz"
    html.html_safe
  end

  def cpu
    html = ""
    if model.nb_proc.present? && model.nb_proc > 0
      html << cores
      html << "<br />(#{model.ref_proc})" if model.ref_proc.present?
    else
      html << "?"
    end
    html.html_safe
  end

  def disks
    html = ""
    if model.disk_size.present? && model.disk_size > 0
      html << "#{model.nb_disk} * " unless model.nb_disk.blank? || model.nb_disk == 1
      html << "#{model.disk_size}G"
      html << " (#{model.disk_type})" unless model.disk_type.blank?
      if model.disk_size_alt.present? && model.disk_size_alt > 0
        html << "<br />"
        html << "#{model.nb_disk_alt} * " unless model.nb_disk_alt.blank? || model.nb_disk_alt == 1
        html << "#{model.disk_size_alt}G"
        html << " (#{model.disk_type_alt})" unless model.disk_type_alt.blank?
      end
    else
      html << "?"
    end
    html.html_safe
  end

  def ram
    html = ""
    if model.memory.present? && model.memory.to_f > 0
      html = model.memory.to_s + (model.memory.to_s.match(/[MG]/) ? "Go" : "")
    else
      html << "?"
    end
    html
  end

  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #   
  #   Or, optionally enable "lazy helpers" by calling this method:
  #     lazy_helpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #   
  #   def created_at
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"), 
  #                   :class => 'timestamp'
  #   end
end