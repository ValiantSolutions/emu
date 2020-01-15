# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SchedulesController, type: :request do
  describe 'default denies access to schedules', type: :request do
    it do
      get new_schedule_path
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'factory' do
    it 'is valid' do
      @schedule = FactoryBot.create(:schedule)
      expect(@schedule).to be_valid
    end
  end

  describe 'GET' do
    before(:each) do
      login_user
    end

    it '#index' do
      get schedules_path
      expect(response).to render_template(:index)
    end

    context 'has no alerts' do
      it 'redirects #new' do
        get new_schedule_path
        expect(current_path).to redirect_to(new_permanent_path)
      end
    end

    context 'has alerts' do
      before(:each) do
        @alert = FactoryBot.build(
          :alert,
          conditional: FactoryBot.build(:conditional),
          payload: FactoryBot.build(:payload)
        ).actions << FactoryBot.create(:action)
      end
      it '#new assigns a new class' do
        get new_schedule_path
        expect(assigns(:schedule)).to be_a_new(Schedule)
      end

      it '#edit' do
        @schedule = FactoryBot.create(:schedule)
        get edit_schedule_path(@schedule)
        expect(response).to render_template(:edit)
      end

      it '#edit assigns class appropriately' do
        @schedule = FactoryBot.create(:schedule)
        get edit_schedule_path(@schedule)
        expect(assigns(:schedule)).to eq(@schedule)
      end
    end
  end

  describe 'POST' do
    before(:each) do
      login_user
      @alert = FactoryBot.build(
          :alert,
          conditional: FactoryBot.build(:conditional),
          payload: FactoryBot.build(:payload),
          search: Search.first || FactoryBot.create(:search)
        )
      @alert.actions << FactoryBot.create(:action)
      @alert.save!
      @schedule = FactoryBot.attributes_for(:schedule, alert_id: @alert.id)
    end

    context 'valid attributes' do
      it 'redirects to index page' do
        post schedules_path, params: {schedule: @schedule}
        expect(current_path).to redirect_to(schedules_path)
      end

      it 'expects the count to increase by 1' do
        expect do
          post schedules_path, params: {schedule: @schedule}
        end.to change(Schedule, :count).by(1)
      end
    end

    context 'invalid attributes' do
      it 'does not create the model' do
        expect do
          post schedules_path, params: {schedule: FactoryBot.attributes_for(:invalid_schedule)}
        end.not_to change { Schedule.count }
      end
    end
  end

  describe 'PUT' do
    before(:each) do
      login_user
      @alert = FactoryBot.build(
          :alert,
          conditional: FactoryBot.build(:conditional),
          payload: FactoryBot.build(:payload),
          search: Search.first || FactoryBot.create(:search)
        )
      @alert.actions << FactoryBot.create(:action)
      @alert.save!
      @schedule = FactoryBot.create(:schedule, alert_id: @alert.id)
    end

    context 'valid attributes' do
      it 'located the model' do
        put schedule_path(@schedule), params: {schedule: FactoryBot.attributes_for(:schedule)}
        expect(assigns(:schedule)).to eq @schedule
      end

      it 'changes attributes' do
        put schedule_path(@schedule),
            params: {
              schedule: FactoryBot.attributes_for(
                :schedule,
                cron: '* * * * *'
              )
            }
        @schedule.reload
        expect(@schedule.cron).to eq('* * * * *')
      end

      it 'redirects to the index method' do
        put schedule_path(@schedule), params: {schedule: FactoryBot.attributes_for(:schedule)}
        expect(current_path).to redirect_to(schedules_path)
      end

      it 'triggers the job' do
        put trigger_schedules_path(@schedule), params: {schedule: FactoryBot.attributes_for(:schedule)}
        expect(response).to have_http_status(200)
      end
    end

    context 'invalid attributes' do
      it 'does not modify the model' do
        put schedule_path(@schedule), params: {schedule: FactoryBot.attributes_for(:invalid_schedule)}
        expect(assigns(:schedule)).to eq @schedule
      end

      it 're-renders the edit template' do
        put schedule_path(@schedule), params: {schedule: FactoryBot.attributes_for(:invalid_schedule)}
        expect(current_path).to render_template(:edit)
      end
    end
  end

  describe 'DELETE' do
    before(:each) do
      login_user
      @alert = FactoryBot.build(
          :alert,
          conditional: FactoryBot.build(:conditional),
          payload: FactoryBot.build(:payload),
          search: Search.first || FactoryBot.create(:search)
        )
      @alert.actions << FactoryBot.create(:action)
      @alert.save!
      @schedule = FactoryBot.create(:schedule, alert_id: @alert.id)
    end

    it 'deletes the model' do
      expect do
        delete schedule_path(@schedule)
      end.to change(Schedule, :count).by(-1)
    end

    it 'redirects to the index method' do
      delete schedule_path(@schedule)
      expect(current_path).to redirect_to(schedules_path)
    end
  end
end