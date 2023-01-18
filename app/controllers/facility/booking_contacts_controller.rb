class Facility::BookingContactsController < ApplicationController
  def index
    @booking_contacts = current_facility.booking_contacts
  end

  def show
    @booking_contact = BookingContact.find(params[:id])
  end

  def reply
    @booking_contact = BookingContact.find(params[:booking_contact_id])
    if @booking_contact.update(status: "bookable")
      flash[:notice] = "予約可能で返答しました。"
      render :show
    else
      flash[:alert] = "返答の送信に失敗しました。"
      render :show
    end
  end
end
