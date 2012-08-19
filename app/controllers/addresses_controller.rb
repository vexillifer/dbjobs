class AddressesController < ApplicationController

  def subregion_options
    render partial: 'addresses/subregion_select'
  end

 end