class GroupMembersController < ApplicationController
  before_action :set_group, :authorize_group_members
  after_action :verify_authorized

  def index
    authorize @group, :show?
  end

  def new
    @group_member_form = GroupMemberForm.new
  end

  def create
    @group_member_form = GroupMemberForm.new(group_member_params)
    if @group_member_form.save
      redirect_to group_members_path(@group.external_id)
    else
      render :new, status: :unprocessable_entity
    end
  end

private

  def set_group
    @group = Group.find_by(external_id: params[:group_id])
  end

  def group_member_params
    params.require(:group_member_form).permit(:member_email_address).merge(group: @group, creator: current_user)
  end

  def group_member_params
    params.require(:group_member_form).permit(:member_email_address).merge(group: @group, creator: current_user)
  end
end
