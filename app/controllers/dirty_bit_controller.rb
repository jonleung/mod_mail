class DirtyBitController < ApplicationController

  def get
    DirtyBit.make_dirty(params[:key])
    redirect_to "http://i.imgur.com/xr80qqX.gif"
  end

end