class HomesController < ApplicationController
  def top
    if care_manager_signed_in?
      redirect_to care_manager_use_plans_path
    elsif facility_signed_in?
      redirect_to facility_booking_contacts_path
    end
  end

  def sign_in
    @care_manager = CareManager.new
    @facility = Facility.new
  end
end
