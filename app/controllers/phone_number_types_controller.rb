class PhoneNumberTypesController < ApplicationController
  # GET /phone_number_types
  # GET /phone_number_types.xml
  def index
    @phone_number_types = PhoneNumberType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @phone_number_types }
    end
  end

  # GET /phone_number_types/1
  # GET /phone_number_types/1.xml
  def show
    @phone_number_type = PhoneNumberType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @phone_number_type }
    end
  end

  # GET /phone_number_types/new
  # GET /phone_number_types/new.xml
  def new
    @phone_number_type = PhoneNumberType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @phone_number_type }
    end
  end

  # GET /phone_number_types/1/edit
  def edit
    @phone_number_type = PhoneNumberType.find(params[:id])
  end

  # POST /phone_number_types
  # POST /phone_number_types.xml
  def create
    @phone_number_type = PhoneNumberType.new(params[:phone_number_type])

    respond_to do |format|
      if @phone_number_type.save
        flash[:notice] = 'PhoneNumberType was successfully created.'
        format.html { redirect_to(@phone_number_type) }
        format.xml  { render :xml => @phone_number_type, :status => :created, :location => @phone_number_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @phone_number_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /phone_number_types/1
  # PUT /phone_number_types/1.xml
  def update
    @phone_number_type = PhoneNumberType.find(params[:id])

    respond_to do |format|
      if @phone_number_type.update_attributes(params[:phone_number_type])
        flash[:notice] = 'PhoneNumberType was successfully updated.'
        format.html { redirect_to(@phone_number_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @phone_number_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_number_types/1
  # DELETE /phone_number_types/1.xml
  def destroy
    @phone_number_type = PhoneNumberType.find(params[:id])
    @phone_number_type.destroy

    respond_to do |format|
      format.html { redirect_to(phone_number_types_url) }
      format.xml  { head :ok }
    end
  end
end
