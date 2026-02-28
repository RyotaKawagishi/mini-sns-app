#!/usr/bin/env ruby
# frozen_string_literal: true

# Vercel serverless function entry point for Rails application
# This file is required for Vercel to handle Rails requests

require_relative '../config/environment'

# Rack application
run Rails.application
