class Api::ShiftGeneratorsController < ApplicationController

  @@genoms = []

  def show
    if user_signed_in? && current_user.admin?
      users = User.where(role: "employee").includes(:attendances)
      @workroles = WorkRole.all
      sgg = ShiftGeneticGenerator.new(users, @workroles)
      @genoms = sgg.generate(period_params)
      @@genoms = @genoms
    else
      redirect_to root_path
    end
  end

  def create
    shifts = Shift.build_from_genoms(@@genoms)
    # TODO バルクインサート時のエラーハンドリング処理
    if true
      Shift.import! shifts
      redirect_to root_path
    else
      @workroles = WorkRole.all
      @genoms = @@genoms
      render :show
    end
  end

  def update
    # 今のworkroleに+1したものが存在すれば+1したものを、無ければ0(アサイン無し)をafter_roleとする
    after_role = WorkRole.ids.include?(params[:workrole_id].to_i + 1) ? params[:workrole_id].to_i + 1 : 0
    # クリックされたgenomsを特定し、after_roleで更新する
    # TODO genom_indexではなく日付で特定したい
    @@genoms[params[:genom_index].to_i][:shifts][params[:shift_index].to_i][:array][params[:shift_in_at].to_i] = after_role
    @genom_info = {
      date: params[:day],
      shift_in_at: params[:shift_in_at],
      before_role: params[:workrole_id],
      after_role: after_role
    }
    render :update, formats: :json
  end

  private

  def period_params
    @period = params.permit(:start, :finish)
  end

end
