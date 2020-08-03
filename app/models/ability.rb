# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    if user.present?
      can :show, Course, id: user.courses_ids, isdeleted: Course.isdeleteds[:avaiable]
      can :show, [Subject, Task]
      can :create, UserSubject
      can :update, UserSubject, user_id: user.id
      can :update, ProcessTask, user_id: user.id
      can [:show, :update], User, id: user.id
      if user.trainer?
        can :manage, Course, isdeleted: Course.isdeleteds[:avaiable]
        can :read, Course, isdeleted: Course.isdeleteds[:deleted]
        can :manage, Subject
        can :manage, UserSubject
        can :manage, Task do |task|
          task.subject_id = task.subject.id
        end
        can :manage, User, role: User.roles[:trainee]
        can [:create], UserCourse
        can [:create, :update], CourseDetail
      end
    end
  end
end
