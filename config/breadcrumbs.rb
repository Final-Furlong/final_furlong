crumb :root do
  link t("breadcrumbs.home"), root_path
end

crumb :users do
  link t("breadcrumbs.users"), users_path
end

crumb :new_user do
  link t("breadcrumbs.new_user")
  parent :users
end

crumb :edit_user do |user|
  link user.name, user_path(user)
  link t("breadcrumbs.edit")
  parent :users
end

crumb :user do |user|
  link user.name, user_path(user)
  parent :users
end

crumb :horses do
  link t("breadcrumbs.horses"), horses_path
end

crumb :edit_horse do |horse|
  link horse.name, horse_path(horse)
  link t("breadcrumbs.edit")
  parent :horses
end

crumb :horse do |horse|
  link horse.name, horse_path(horse)
  parent :horses
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).

