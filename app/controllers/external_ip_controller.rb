class ExternalIpController < ApplicationController

  def test
    render json: true.to_json
  end

end