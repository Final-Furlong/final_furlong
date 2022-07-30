require "reform/form/dry"
require "reform/form/active_model"
require "reform/form/active_model/validations"

Rails.application.config.reform.validations = :dry

Reform::Form.class_eval do
  feature Reform::Form::Dry
end
