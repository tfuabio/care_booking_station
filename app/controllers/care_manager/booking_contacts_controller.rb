class CareManager::BookingContactsController < ApplicationController
  def create
    @use_plan = UsePlan.find(params[:use_plan_id])
    booking_contact = @use_plan.booking_contacts.new(booking_contact_params)
    @booking_contact = BookingContact.new
    @facilities = Facility.all
    @booking_contacts = @use_plan.booking_contacts
    if booking_contact.contacted?
      flash.now[:alert] = "#{booking_contact.facility.name}への問い合わせはすでに送信済みのため送信を中止しました。"
    else
      if booking_contact.save
        flash.now[:notice] = "#{booking_contact.facility.name}へ問い合わせを送信しました。"
      else
        flash.now[:alert] = "問い合わせに失敗しました。"
      end
    end
    render 'care_manager/use_plans/show'
  end

  private

  def booking_contact_params
    params.require(:booking_contact).permit(:facility_id)
  end
end
