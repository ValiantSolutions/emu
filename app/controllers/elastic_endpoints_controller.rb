# frozen_string_literal: true

class ElasticEndpointsController < ApplicationController
  before_action :set_elastic_endpoint, only: %i[show edit update destroy]

  breadcrumb 'Elasticsearch', '', match: :exact

  # GET /elastic_endpoints
  # GET /elastic_endpoints.json
  def index
    breadcrumb 'Clusters', elastic_endpoints_path, match: :exact
    @endpoints = policy_scope(ElasticEndpoint.all)
  end

  # GET /elastic_endpoints/new
  def new
    breadcrumb 'Clusters', elastic_endpoints_path, match: :exact
    breadcrumb 'New Cluster Configuration', new_elastic_endpoint_path, match: :exact
    @elastic_endpoint = ElasticEndpoint.new
  end

  # GET /elastic_endpoints/1/edit
  def edit
    breadcrumb 'Clusters', elastic_endpoints_path, match: :exact
    breadcrumb 'Edit Cluster', edit_elastic_endpoint_path(@elastic_endpoint), match: :exact
  end

  def show
    EndpointWorker.perform_async(@elastic_endpoint.id)
    respond_to do |format|
      format.html { redirect_to elastic_endpoints_path }
      format.json { render :show, status: :ok, location: @elastic_endpoint }
    end
  end

  # POST /elastic_endpoints
  # POST /elastic_endpoints.json
  def create
    breadcrumb 'Clusters', elastic_endpoints_path, match: :exact
    breadcrumb 'New Cluster Configuration', new_elastic_endpoint_path, match: :exact

    @elastic_endpoint = ElasticEndpoint.new(elastic_endpoint_params)

    @elastic_endpoint.user = current_user
    @elastic_endpoint.status = :unknown
    @elastic_endpoint.address = clean_address(elastic_endpoint_params[:address])

    authorize @elastic_endpoint

    respond_to do |format|
      if @elastic_endpoint.save
        EndpointWorker.perform_async(@elastic_endpoint.id)
        format.html { redirect_to elastic_endpoints_path, notice: 'Cluster was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /elastic_endpoints/1
  # PATCH/PUT /elastic_endpoints/1.json
  def update
    respond_to do |format|
      params = elastic_endpoint_params
      @elastic_endpoint.address = clean_address(elastic_endpoint_params[:address])

      if @elastic_endpoint.update(params)
        EndpointWorker.perform_async(@elastic_endpoint.id)
        format.html { redirect_to elastic_endpoints_path, notice: "#{@elastic_endpoint.name} was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /elastic_endpoints/1
  # DELETE /elastic_endpoints/1.json
  def destroy
    @elastic_endpoint.destroy
    respond_to do |format|
      format.html { redirect_to elastic_endpoints_url, notice: "#{@elastic_endpoint.name} was deleted successfully." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_elastic_endpoint
    @elastic_endpoint = authorize ElasticEndpoint.find(params[:id])
  end

  def clean_address(address)
    address.gsub(%r{\Ahttp[s]?://}, '').gsub(/:.*\z/, '')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def elastic_endpoint_params
    dirty_endpoint_params = params.require(:elastic_endpoint).permit(
      :name,
      :address,
      :port,
      :verify_ssl,
      :username,
      :password,
      :protocol
    )
    if dirty_endpoint_params.key?(:address)
      dirty_endpoint_params[:address] = clean_address(dirty_endpoint_params[:address])
    end

    if dirty_endpoint_params.key?(:password) && dirty_endpoint_params[:password].blank?
      dirty_endpoint_params.delete :password
    end
    dirty_endpoint_params
  end
end
