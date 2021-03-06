# -*- coding: utf-8 -*-
class Admin::PetsController < Admin::ApplicationController
  before_filter :find_pet, :except => [:index, :new, :create]

  def index
    @pets = Pet.where(params[:search])
  end

  def show
    @photos = @pet.photos
  end

  def new
    @pet = Pet.new
    @mothers = Pet.bitches
    @fathers = Pet.dogs
  end

  def create
    @pet = Pet.new(params[:pet])

    if @pet.save
      @pet.assign_persons({
        :owner => params[:new_owner_name],
        :breeder => params[:new_breeder_name],
        :kennel => params[:new_kennel_name]
      })
      @pet.assign_parents(params[:new_mother_name], params[:new_father_name])
      flash[:info] = "Добавлен питомец '#{@pet.name}'"
    end

    redirect_to session[:back_url] || admin_pets_path
  end

  def edit
    descendants = @pet.descendants
    @mothers = Pet.bitches.where('id != ?', @pet.id) - descendants
    @fathers = Pet.dogs.where('id != ?', @pet.id) - descendants
  end

  def update
    if @pet.update_attributes(params[:pet])
      @pet.assign_persons({
        :owner => params[:new_owner_name],
        :breeder => params[:new_breeder_name],
        :kennel => params[:new_kennel_name]
      })
      @pet.assign_parents(params[:new_mother_name], params[:new_father_name])
      flash[:info] = "Питомец '#{@pet.name}' успешно обновлен"
    else
      flash[:error] = "Что-то пошло не так"
    end
    redirect_to session[:back_url] || admin_pets_path
  end

  def destroy
    @pet.destroy
    flash[:info] = "Питомец '#{@pet.name}' удалён"
    redirect_to :back
  end

  private
    def find_pet
      @pet = Pet.find(params[:id])
    end
end
