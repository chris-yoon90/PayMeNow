class GroupsController < ApplicationController
  def index
  	@groups = Group.paginate(page: params[:page])
  end

  def show
  	@group = Group.find(params[:id])
  	@members = @group.members.paginate(page: params[:page])
  end

  def edit
  	@group = Group.find(params[:id])
  end

  def update
  	@group = Group.find(params[:id])
  	if @group.update_attributes(group_params)
  		flash[:success] = "Update is successful!"
  		redirect_to @group
  	else
  		render 'edit'
  	end
  end

  def new
  	@group = Group.new
  end

  def create
  	@group = Group.new(group_params)
  	if @group.save
  		flash[:success] = "New group is created!"
  		redirect_to @group
  	else
  		render 'new'
  	end
  end

  def destroy
  	group = Group.find(params[:id])
  	deleted_group = group.destroy
  	flash[:success] = "Group '#{deleted_group.name}' has been deleted."
  	redirect_to groups_path
  end

  private
  	def group_params
  		params.require(:group).permit(:name)
  	end

end
