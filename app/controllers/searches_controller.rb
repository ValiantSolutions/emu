# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :set_search, only: %i[show edit results update destroy]
  before_action :set_elastic_endpoints, only: %i[index new]

  breadcrumb 'Elasticsearch', '', match: :exact

  # GET /searches
  # GET /searches.json
  def index
    breadcrumb 'Saved Searches', searches_path, match: :exact
    @searches = policy_scope(Search.all)
  end

  # GET /searches/new
  def new
    breadcrumb 'Saved Searches', searches_path, match: :exact
    breadcrumb 'Create Search', new_search_path, match: :exact

    @search = Search.new

    if policy_scope(ElasticEndpoint.all).empty?
      flash[:alert] = 'An Elasticsearch cluster must be defined prior to creating a search!'
      redirect_to :elastic_endpoints
      return
    end
  end

  # GET /searches/1/edit
  def edit
    breadcrumb 'Saved Searches', searches_path, match: :exact
    breadcrumb 'Edit Search', edit_search_path(@search), match: :exact
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)
    
    @search.permanent = true
    @search.user = current_user

    authorize @search

    respond_to do |format|
      if @search.save
        format.html { redirect_to searches_path, notice: 'Search was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to searches_path, notice: "#{@search.name} was successfully updated." } 
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: "#{@search.name} was deleted successfully." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_search
    @search = authorize Search.find(params[:id])
  end

  def set_elastic_endpoints
    @elastic_endpoints = policy_scope(ElasticEndpoint.all)
  end

  def search_params
    params.require(:search).permit(:name, :query, :indices, :elastic_endpoint_id)
  end
end
