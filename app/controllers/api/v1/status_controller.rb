module Api
  module V1
    class StatusController < ApplicationController
      def show
        ActiveRecord::Base.connection.execute("SELECT 1")
        render json: { status: "ok", database: true }
      rescue StandardError
        render json: { status: "ok", database: false }
      end
    end
  end
end
