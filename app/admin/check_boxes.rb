ActiveAdmin.register CheckBox do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :name, :checked, :user_id
  filter :name
  filter :user

  form do |f|
    f.inputs do
      f.input :user
      #TODO 入力欄を指定できる(モデルにenum化した方が良さそう)
      f.input :name, as: :select, collection: ['現場', '通話', 'チャット']
      f.input :checked
    end
    f.actions
  end

  controller do
    def create
      # 権限がmemberならuserを強制的に自分にする
      checkbox_params = permitted_params[:check_box].merge(user: current_user) if current_user.member?
      @check_box = CheckBox.new(checkbox_params)
      if @check_box.save
        redirect_to collection_path
      else
        render :new
      end
    end
  end

end
