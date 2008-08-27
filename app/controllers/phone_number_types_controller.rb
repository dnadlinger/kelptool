class PhoneNumberTypesController < ApplicationController
  def index
    @phone_number_types = PhoneNumberType.find( :all, :order => 'name' )
  end

  def show
    @phone_number_type = PhoneNumberType.find( params[ :id ] )
  end

  def new
    @phone_number_type = PhoneNumberType.new
  end

  def edit
    @phone_number_type = PhoneNumberType.find( params[ :id ] )
  end

  def create
    @phone_number_type = PhoneNumberType.new( params[ :phone_number_type ] )

    if @phone_number_type.save
      flash[ :notice ] = 'Telefonnummer-Kategorie hinzugefügt.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def update
    @phone_number_type = PhoneNumberType.find( params[ :id ] )

    if @phone_number_type.update_attributes( params[ :phone_number_type ] )
      flash[ :notice ] = 'Änderungen gespeichert.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @phone_number_type = PhoneNumberType.find( params[ :id ] )
    @phone_number_type.destroy
    flash[ :notice ] = 'Telefonnummer-Kategorie gelöscht.'
    redirect_to :action => 'index'
  end
end
