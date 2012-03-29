# -*- coding: utf-8 -*-
class PetsController < ApplicationController

  def index
    @pets = Pet.where(params[:search])
  end

  def show
    @pet = Pet.find(params[:id])
    @albums_photos = @pet.photos.with_album.group_by(&:album)
    @unsorted_photos = @pet.photos.unsorted
    @parents = @pet.parents
    @grandparents = Pet.extend_parents(@pet.parents)
    @elders = Pet.extend_parents(@grandparents)
  end

end
