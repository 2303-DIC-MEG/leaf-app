FactoryBot.define do
  factory :task do
    title { 'test_title' }
    content { 'test_content' }
    expired_at {"2023-05-07 13:55:56"}
    status {"Completed"}
    priority {2}
  end
  factory :second_task, class: Task do
    title { 'test_title_2' }
    content { 'test_content_2' }
    expired_at {"2023-05-07 13:55:56"}
    status {"Not staeted"}
    priority {1}
  end
end
