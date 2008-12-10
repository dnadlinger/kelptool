class SkillsController < ApplicationController
  def index
    @skills = Skill.find( :all, :order => :name )
  end

  def show
    @skill = Skill.find( params[ :id ] )
    respond_to do |format|
      format.html do
        @skills = Skill.find( :all, :order => :name )
        render :action => 'index'
      end
      format.js
    end
  end

  def new
    @skill = Skill.new
  end
  
  def create
    @skill = Skill.new( params[ :skill ] )
    if @skill.save
      flash[ :notice ] = 'Fähigkeit definiert.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @skill = Skill.find( params[ :id ] )
  end
  
  def update
    @skill = Skill.find( params[ :id ] ) 
    if @skill.update_attributes( params[ :skill ] )
      flash[ :notice ] = 'Änderungen gespeichert.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @skill = Skill.find( params[ :id ] )
    @skill.destroy
    flash[ :notice ] = 'Fähigkeit gelöscht.'
    redirect_to :action => 'index'
  end
  
  def auto_complete_for_skill_name
    query = params[ :search_query ]
    
    skills = Skill.find( :all,
      :conditions => [ 'LOWER(name) LIKE ?', '%' + query.downcase + '%' ], 
      :order => 'name ASC',
      :limit => 10
    )
    render :inline => '<%= auto_complete_result skills, :name, query, 25 %>',
      :locals => { :skills => skills, :query => query }
  end  
end
