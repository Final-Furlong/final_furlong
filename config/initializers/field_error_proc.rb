# remove the default wrapper to avoid inputs/labels from rendering weirdly
# https://www.rorvswild.com/blog/2026/advanced-domain-modeling-supercharge-rails-forms
ActionView::Base.field_error_proc = proc { |html_tag, _instance| html_tag }

