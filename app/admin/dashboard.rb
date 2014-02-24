ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      column do
        panel t("active_admin.users") do
          ul do
            li t('active_admin.dashboard_info.total_users', count: User.count)
            li t('active_admin.dashboard_info.today_users', count: User.today.count)
          end
        end

        panel 'Sidekiq' do
          link_to t('active_admin.dashboard_info.sidekiq_ui'), sidekiq_web_path, target: "_blank"
        end        
      end

      column do
        panel t("active_admin.articles") do
          para t('active_admin.dashboard_info.total_articles', count: Article.count)
        end
      end
    end
  end # content
end
