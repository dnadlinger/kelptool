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
  		flash[ :notice ] = 'Die Fähigkeit wurde definiert.'
  		redirect_to skills_path
  	else
  		render :action => 'new'
  	end
  end

  def edit
  	@skill = Skill.find( params[ :id ] )
	end
	
  def generate_skill_field
    # Only render RJS template.
  end
  
	def auto_complete_for_skill_name
    @skills = Skill.find( :all,
      :conditions => [ 'LOWER(name) LIKE ?', '%' + params[ :employee ][ :skills_attributes ][0][ :name ].downcase + '%' ], 
      :order => 'name ASC',
      :limit => 10
    )
  end  
end
