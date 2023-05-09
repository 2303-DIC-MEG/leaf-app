require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:task) { FactoryBot.create(:task, title: 'task') }
  
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in "task[title]", with: "task_name"
        fill_in "task[content]", with: "task_content"
        fill_in 'task_expired_at', with: DateTime.new(2024, 9, 1, 18, 30)
        select 'Not started', from: 'task[status]'
        select 'High', from: 'task[priority]'
        click_on "登録する"
        expect(page).to have_content "Task was successfully created."
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content 'task'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit tasks_path
        expect(page).to have_content 'task'
      end
    end
  end
  context 'タスクが作成日時の降順に並んでいる場合' do
    it '新しいタスクが一番上に表示される' do
      visit tasks_path
      task_list = all('.task_list')
      expect(task_list.first).to have_content 'task'
    end
  end
  context 'タスクが終了期限の降順に並んでいる場合' do
    it '終了期限が一番近いタスクが表示される' do
      visit tasks_path
      task_list = all('.task_list')
      click_on "deadline▼"
      expect(task_list.first).to have_content 'task'
    end
  end
  describe '検索機能' do
    before do
      visit tasks_path
    end
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        fill_in "task[title]", with: "task"
        click_on 'search'
        expect(page).to have_content 'task'
      end
    end
    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        select 'Completed',from: 'task_status'
        click_on 'search'
        expect(page).to have_content 'Completed'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        fill_in 'task[title]', with: 'task'
        select 'Completed',from: 'task_status'
        click_on 'search'
        expect(page).to have_content 'task'
        expect(page).to have_content 'Completed'
      end
    end
  end
end


