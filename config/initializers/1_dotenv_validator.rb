# frozen_string_literal: true

Rails.logger.debug "Validating environment... 🧐🧐🧐"
DotenvValidator.check!
Rails.logger.debug "Your environment is in good shape! 🚀🚀🚀"
