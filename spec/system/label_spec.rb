require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:label) { FactoryBot.create(:label) }

  #何故か実装できなかった。。。
  # before do
  #   visit new_session_path
  #   fill_in 'Email', with: user.email
  #   fill_in 'Password', with: user.password
  #   click_on 'Log in'
  # end
  
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it 'ラベルが表示される' do
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'Log in'
        visit new_task_path
        fill_in "task[title]", with: "task_name"
        fill_in "task[content]", with: "task_content"
        fill_in 'task_expired_at', with: DateTime.new(2024, 9, 1, 18, 30)
        select 'Not started', from: 'task[status]'
        select 'High', from: 'task[priority]'
        check 'test'
        click_on "登録する"
        expect(page).to have_content "Task was successfully created."
      end
    end
    context "タスクを編集した場合" do
      it "ラベルが編集できる" do
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'Log in'
        visit new_task_path
        fill_in "task[title]", with: "task_name"
        fill_in "task[content]", with: "task_content"
        fill_in 'task_expired_at', with: DateTime.new(2024, 9, 1, 18, 30)
        select 'Not started', from: 'task[status]'
        select 'High', from: 'task[priority]'
        check 'test'
        click_on "登録する"
        click_on "Edit"
        click_on "更新する"
        expect(page).to have_content"Task was successfully updated."
      end
    end
  end
  describe 'ラベル検索機能' do
    context 'ラベル検索をした場合' do
      it "該当ラベルを絞り込まれる" do
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'Log in'
        visit new_task_path
        fill_in "task[title]", with: "task_name"
        fill_in "task[content]", with: "task_content"
        fill_in 'task_expired_at', with: DateTime.new(2024, 9, 1, 18, 30)
        select 'Not started', from: 'task[status]'
        select 'High', from: 'task[priority]'
        check 'test'
        click_on "登録する"
        visit tasks_path
        select 'test',from: 'task_label_id'
        click_on 'search'
        expect(page).to have_content 'test'
      end
    end
  end
end