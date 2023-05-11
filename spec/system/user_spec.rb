require 'rails_helper'
RSpec.describe 'ユーザ管理機能', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:second_user) { FactoryBot.create(:second_user) }
  
  describe 'ユーザ新規作成機能' do
    context 'ユーザを新規登録した場合' do
      it 'タスク一覧画面に遷移すること' do
        visit new_user_path
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: 'test@gmail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_on "Create my account"
        expect(page).to have_content 'Task'
      end
    end
    context 'ユーザがログインせずタスク一覧画面に飛ぼうとした場合' do
      it 'ログイン画面に遷移する' do
        visit tasks_path
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe 'セッション機能のテスト' do
    context 'ログインした場合' do
      it '自分の詳細画面(マイページ)に飛べる' do
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'Log in'
        expect(page).to have_content 'Welcome!!' 
      end
    end
    context '一般ユーザが他人の詳細画面に飛んだ場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on "Log in"
        visit  user_path(second_user)
        expect(current_path).to eq tasks_path
      end
    end
    context 'ログイン後' do
      it 'ログアウトができる' do
        visit new_session_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on "Log in"
        click_link "Logout"
        expect(current_path).to eq new_session_path
      end
    end
    describe '管理画面のテスト' do
      context '管理ユーザが管理画面にアクセスした場合' do
        it '管理画面にアクセス出来る' do
          visit new_session_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_on "Log in"
          visit admin_users_path
          expect(current_path).to eq admin_users_path
        end
      end
      context '一般ユーザが管理画面にアクセスした場合' do
        it '管理画面にアクセス出来ない' do
          visit new_session_path
          fill_in 'Email', with: second_user.email
          fill_in 'Password', with: second_user.password
          click_on "Log in"
          visit admin_users_path
          expect(current_path).not_to eq admin_users_path
        end
      end
  
      context '管理ユーザーがユーザーの新規登録をした場合' do
        it 'ユーザの新規登録ができる' do
          visit new_session_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_on "Log in"
          visit admin_users_path
          click_button "New Task"
          fill_in 'user[name]', with: 'testtest'
          fill_in 'user[email]', with: 'testtest@gmail.com'
          fill_in 'user[password]', with: 'testpass'
          fill_in 'user[password_confirmation]', with: 'testpass'
          select 'Public', from: :user_admin
          click_on "Create my account"
          visit admin_users_path
          expect(current_path).to eq admin_users_path
        end
      end
      context '管理ユーザーはユーザーの詳細にアクセスをした場合' do
        it 'ユーザーの詳細画面が表示される' do
          visit new_session_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_on "Log in"
          visit admin_users_path
          visit admin_user_path(user)
          expect(current_path).to eq admin_user_path(user)
        end
      end
  
      context '管理ユーザーはユーザーの編集画面で名前と権限を編集した場合' do
        it 'ユーザーの詳細画面で変更後の名前が表示される' do
          visit new_session_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_on "Log in"
          visit admin_users_path
          visit edit_admin_user_path(second_user)
          fill_in 'user[name]', with: second_user.name
          fill_in 'user[email]', with: second_user.email
          fill_in 'user[password]', with: second_user.password
          fill_in 'user[password_confirmation]', with: second_user.password
          select 'Public', from: :user_admin
          click_on "登録"
          visit admin_user_path(user)
          expect(page).to have_content user.name
        end
      end
  
      context '管理ユーザがユーザ一覧画面の削除をクリックした場合' do
        it 'ユーザの削除ができる' do
          visit new_session_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_on "Log in"
          visit admin_users_path
          click_on 'Destroy', match: :first
          expect(page).to have_content user.name
        end
      end
    end
  end
end