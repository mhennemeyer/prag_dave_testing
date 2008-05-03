class StisController < ApplicationController
  # GET /stis
  # GET /stis.xml
  def index
    @stis = Sti.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stis }
    end
  end

  # GET /stis/1
  # GET /stis/1.xml
  def show
    @sti = Sti.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sti }
    end
  end

  # GET /stis/new
  # GET /stis/new.xml
  def new
    @sti = Sti.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sti }
    end
  end

  # GET /stis/1/edit
  def edit
    @sti = Sti.find(params[:id])
  end

  # POST /stis
  # POST /stis.xml
  def create
    @sti = Sti.new(params[:sti])

    respond_to do |format|
      if @sti.save
        flash[:notice] = 'Sti was successfully created.'
        format.html { redirect_to(@sti) }
        format.xml  { render :xml => @sti, :status => :created, :location => @sti }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sti.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stis/1
  # PUT /stis/1.xml
  def update
    @sti = Sti.find(params[:id])

    respond_to do |format|
      if @sti.update_attributes(params[:sti])
        flash[:notice] = 'Sti was successfully updated.'
        format.html { redirect_to(@sti) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sti.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stis/1
  # DELETE /stis/1.xml
  def destroy
    @sti = Sti.find(params[:id])
    @sti.destroy

    respond_to do |format|
      format.html { redirect_to(stis_url) }
      format.xml  { head :ok }
    end
  end
end
