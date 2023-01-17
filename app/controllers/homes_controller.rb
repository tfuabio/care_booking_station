class HomesController < ApplicationController
  def top
  end

  def sign_in
    @care_manager = CareManager.new
    @facility = Facility.new
  end
end
