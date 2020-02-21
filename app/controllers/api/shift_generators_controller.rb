class Api::ShiftGeneratorsController < ApplicationController

  def show
    if user_signed_in? && current_user.admin?
      users = User.where(role: "employee").includes(:attendances)
      @workroles = WorkRole.all
      # sgg = ShiftGeneticGenerator.new(users, @workroles)
      # @genoms = sgg.generate(period_params)
      @genoms = test_genoms
      @@genoms = test_genoms
      # session[:genoms] = test_genoms
    else
      redirect_to root_path
    end
  end

  def create
    binding.pry
  end

  def update
    next_role = params[:workrole_id].to_i + 1
    @@genoms[params[:genom_index].to_i][:shifts][params[:shift_index].to_i][:array][params[:shift_in_at].to_i] = next_role
    @genom_info = {
      genom_index: params[:genom_index],
      shift_index: params[:shift_index],
      shift_in_at: params[:shift_in_at],
    }
    @genom_info[:workrole_id] = WorkRole.count < next_role ? 0 : next_role
    render :update, formats: :json
  end

  private

  def period_params
    @period = params.permit(:start, :finish)
  end

  def test_genoms
    [
      {:this_day=>DateTime.new(2020,2,1),
       :required=>
        [{:workrole=>{:id=>1, :name=>"Bernhard and Sons"}, :array=>[9, 0, 1, 1, 1, 1, 2, 3, 3, 0, 0, 5, 5, 5, 5, 5, 5, 6, 7, 8, 8, 8, 9, 9]},
         {:workrole=>{:id=>2, :name=>"Kassulke Inc"}, :array=>[5, 5, 6, 6, 7, 7, 7, 8, 8, 9, 9, 9, 0, 0, 1, 1, 1, 2, 2, 3, 3, 0, 0, 0]},
         {:workrole=>{:id=>3, :name=>"Gleichner, Fisher and Brekke"}, :array=>[6, 6, 7, 7, 9, 9, 9, 0, 0, 1, 1, 1, 1, 2, 3, 3, 3, 3, 3, 3, 0, 0, 0, 6]},
        ],
       :sum=>
        [{:workrole=>{:id=>1, :name=>"Bernhard and Sons"}, :array=>[0, 0, 1, 1, 1, 1, 2, 3, 3, 0, 0, 5, 5, 5, 5, 5, 5, 6, 7, 8, 8, 8, 6, 0]},
         {:workrole=>{:id=>2, :name=>"Kassulke Inc"}, :array=>[0, 5, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 0, 0, 1, 1, 1, 2, 2, 3, 3, 0, 0, 0]},
         {:workrole=>{:id=>3, :name=>"Gleichner, Fisher and Brekke"}, :array=>[0, 0, 0, 0, 0, 0, 7, 0, 0, 1, 1, 1, 1, 2, 3, 3, 3, 3, 3, 3, 2, 0, 0, 0]},
        ],
       :shifts=>
        [{:user_id=>2, :array=>[nil, nil, nil, nil, nil, nil, 3, 2, 2, 2, 1, 2, 0, 0, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.7777777777777778},
         {:user_id=>3, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 1, 2, 2, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>4, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 3, 0, 1, 0, 3, 0, 3, nil, nil, nil, nil], :evaluation=>0.7102857102857103},
         {:user_id=>5, :array=>[nil, nil, nil, 3, 3, 2, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>6, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 1, 0, 2, nil, nil, nil], :evaluation=>0.8333333333333330},
         {:user_id=>7, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, 2, 0, 1, 1, 3, 0, 2, 0, 1, 1, 1, nil, nil], :evaluation=>0.7272727272727273},
         {:user_id=>8, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, 0, 3, 3, 1, 1, nil], :evaluation=>1.0},
         {:user_id=>9, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 0, 2, 1, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>10, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 2, 0, 1, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>11, :array=>[nil, nil, nil, nil, nil, nil, 3, 1, 1, 2, 2, 0, 3, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.8571028571028571},
         {:user_id=>12, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 3, 3, 1, 1, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>13, :array=>[nil, nil, 2, 2, 2, 2, 2, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>14, :array=>[1, 2, 2, 3, 3, 3, 3, 1, 0, 2, 1, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.75},
         {:user_id=>15, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 1, 1, 2, 2, 2, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>16, :array=>[nil, nil, nil, 3, 2, 3, 3, 2, 2, 0, 0, 2, 0, 0, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.75},
         {:user_id=>17, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 0, 1, 0, 0, 3, 1, nil, nil, nil, nil], :evaluation=>0.8571028571028571},
         {:user_id=>18, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>19, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, 0, 0, 2, 0, 1, 0, 2, 2, 1, 1, nil], :evaluation=>0.7},
         {:user_id=>20, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>21, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 3, 1, 1, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>22, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, 0, 0, 0, 0, 0, 1, 1, 1, nil], :evaluation=>1.0},
         {:user_id=>23, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 0, 3, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>24, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 2, 0, 0, 0, 0, 0, 0, 0, 3, 1, 1, 1, 1, nil], :evaluation=>0.9230769230769231},
         {:user_id=>25, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>26, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>27, :array=>[1, 2, 2, 1, 1, 3, 2, 2, 1, 1, 0, 0, 1, 0, 0, 0, 3, 1, 1, nil, nil, nil, nil, nil], :evaluation=>0.6666666666666666},
         {:user_id=>28, :array=>[nil, nil, nil, nil, nil, nil, 3, 0, 2, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 3, nil, nil, nil], :evaluation=>0.7102857102857103},
         {:user_id=>29, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 2, 0, 1, 0, 0, 0, 0, 3, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>30, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, 3, 2, 3, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.6666666666666666},
         {:user_id=>31, :array=>[nil, nil, nil, 2, 3, 2, 2, 0, 2, 0, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.75},
         {:user_id=>32, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>33, :array=>[nil, nil, nil, nil, nil, nil, nil, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 3, 1, 1, 1, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>34, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 1, 0, 0, 0, 1, 3, 0, 1, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.75},
         {:user_id=>35, :array=>[nil, nil, nil, nil, nil, nil, 3, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>36, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>37, :array=>[1, 2, 1, 2, 3, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 3, 1, 0, nil, nil, nil, nil, nil, nil], :evaluation=>0.7058823529011765},
         {:user_id=>38, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 3, 0, 0, 0, 3, nil, nil, nil, nil, nil, nil], :evaluation=>0.8},
         {:user_id=>39, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 2, 3, 2, 0, 0, 0, 0, 0, 0, 3, 3, 1, nil, nil, nil], :evaluation=>0.8333333333333330},
         {:user_id=>40, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 1, 1, 1, 1, 1, nil], :evaluation=>1.0},
         {:user_id=>41, :array=>[nil, nil, nil, nil, nil, 2, 3, 2, 2, 0, 0, 2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.6666666666666666},
         {:user_id=>42, :array=>[nil, nil, nil, nil, 2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>43, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 1, 1, 1, 0, 1, 1, 1, nil, nil], :evaluation=>0.8571028571028571},
         {:user_id=>44, :array=>[nil, nil, nil, 2, 2, 3, 2, 2, 0, 2, 0, 1, 0, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.7},
         {:user_id=>45, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, nil, nil], :evaluation=>0.7272727272727273},
         {:user_id=>46, :array=>[nil, 2, 2, 3, 2, 1, 2, 2, 2, 0, 2, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.6363636363636360},
         {:user_id=>47, :array=>[1, 2, 2, 2, 2, 2, 2, 0, 1, 1, 2, 2, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.8061538061538061},
         {:user_id=>48, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, 0, 0, 0, 0, 0, 0, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>49, :array=>[nil, nil, nil, 2, 2, 2, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
         {:user_id=>50, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, nil], :evaluation=>1.0},
         {:user_id=>51, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0}],
       :evaluation=>0.8802093331505096},
       {:this_day=>DateTime.new(2020,2,2),
        :required=>
         [{:workrole=>{:id=>1, :name=>"Bernhard and Sons"}, :array=>[9, 0, 1, 1, 1, 1, 2, 3, 3, 0, 0, 5, 5, 5, 5, 5, 5, 6, 7, 8, 8, 8, 9, 9]},
          {:workrole=>{:id=>2, :name=>"Kassulke Inc"}, :array=>[5, 5, 6, 6, 7, 7, 7, 8, 8, 9, 9, 9, 0, 0, 1, 1, 1, 2, 2, 3, 3, 0, 0, 0]},
          {:workrole=>{:id=>3, :name=>"Gleichner, Fisher and Brekke"}, :array=>[6, 6, 7, 7, 9, 9, 9, 0, 0, 1, 1, 1, 1, 2, 3, 3, 3, 3, 3, 3, 0, 0, 0, 6]},
        ],
        :sum=>
         [{:workrole=>{:id=>1, :name=>"Bernhard and Sons"}, :array=>[0, 0, 1, 1, 1, 1, 2, 3, 3, 0, 0, 5, 5, 5, 5, 5, 5, 6, 7, 8, 8, 8, 6, 0]},
          {:workrole=>{:id=>2, :name=>"Kassulke Inc"}, :array=>[0, 5, 5, 6, 7, 7, 7, 8, 8, 9, 9, 9, 0, 0, 1, 1, 1, 2, 2, 3, 3, 0, 0, 0]},
          {:workrole=>{:id=>3, :name=>"Gleichner, Fisher and Brekke"}, :array=>[0, 0, 0, 0, 0, 0, 7, 0, 0, 1, 1, 1, 1, 2, 3, 3, 3, 3, 3, 3, 2, 0, 0, 0]},
        ],
        :shifts=>
         [{:user_id=>2, :array=>[nil, nil, nil, nil, nil, nil, 3, 2, 2, 2, 1, 2, 0, 0, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.7777777777777778},
          {:user_id=>3, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 1, 2, 2, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>4, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 3, 0, 1, 0, 3, 0, 3, nil, nil, nil, nil], :evaluation=>0.7102857102857103},
          {:user_id=>5, :array=>[nil, nil, nil, 3, 3, 2, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>6, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 1, 0, 2, nil, nil, nil], :evaluation=>0.8333333333333330},
          {:user_id=>7, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, 2, 0, 1, 1, 3, 0, 2, 0, 1, 1, 1, nil, nil], :evaluation=>0.7272727272727273},
          {:user_id=>8, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, 0, 3, 3, 1, 1, nil], :evaluation=>1.0},
          {:user_id=>9, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 0, 2, 1, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>10, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 2, 0, 1, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>11, :array=>[nil, nil, nil, nil, nil, nil, 3, 1, 1, 2, 2, 0, 3, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.8571028571028571},
          {:user_id=>12, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 3, 3, 1, 1, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>13, :array=>[nil, nil, 2, 2, 2, 2, 2, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>14, :array=>[1, 2, 2, 3, 3, 3, 3, 1, 0, 2, 1, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.75},
          {:user_id=>15, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 1, 1, 2, 2, 2, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>16, :array=>[nil, nil, nil, 3, 2, 3, 3, 2, 2, 0, 0, 2, 0, 0, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.75},
          {:user_id=>17, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 0, 1, 0, 0, 3, 1, nil, nil, nil, nil], :evaluation=>0.8571028571028571},
          {:user_id=>18, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>19, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, 0, 0, 2, 0, 1, 0, 2, 2, 1, 1, nil], :evaluation=>0.7},
          {:user_id=>20, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>21, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 3, 1, 1, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>22, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, 0, 0, 0, 0, 0, 1, 1, 1, nil], :evaluation=>1.0},
          {:user_id=>23, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 0, 3, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>24, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 2, 0, 0, 0, 0, 0, 0, 0, 3, 1, 1, 1, 1, nil], :evaluation=>0.9230769230769231},
          {:user_id=>25, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>26, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>27, :array=>[1, 2, 2, 1, 1, 3, 2, 2, 1, 1, 0, 0, 1, 0, 0, 0, 3, 1, 1, nil, nil, nil, nil, nil], :evaluation=>0.6666666666666666},
          {:user_id=>28, :array=>[nil, nil, nil, nil, nil, nil, 3, 0, 2, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 3, nil, nil, nil], :evaluation=>0.7102857102857103},
          {:user_id=>29, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 2, 0, 1, 0, 0, 0, 0, 3, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>30, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, 3, 2, 3, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.6666666666666666},
          {:user_id=>31, :array=>[nil, nil, nil, 2, 3, 2, 2, 0, 2, 0, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.75},
          {:user_id=>32, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>33, :array=>[nil, nil, nil, nil, nil, nil, nil, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 3, 1, 1, 1, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>34, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 1, 0, 0, 0, 1, 3, 0, 1, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.75},
          {:user_id=>35, :array=>[nil, nil, nil, nil, nil, nil, 3, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>36, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>37, :array=>[1, 2, 1, 2, 3, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 3, 1, 0, nil, nil, nil, nil, nil, nil], :evaluation=>0.7058823529011765},
          {:user_id=>38, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 3, 0, 0, 0, 3, nil, nil, nil, nil, nil, nil], :evaluation=>0.8},
          {:user_id=>39, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, 0, 2, 3, 2, 0, 0, 0, 0, 0, 0, 3, 3, 1, nil, nil, nil], :evaluation=>0.8333333333333330},
          {:user_id=>40, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 0, 1, 1, 1, 1, 1, nil], :evaluation=>1.0},
          {:user_id=>41, :array=>[nil, nil, nil, nil, nil, 2, 3, 2, 2, 0, 0, 2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.6666666666666666},
          {:user_id=>42, :array=>[nil, nil, nil, nil, 2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>43, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, 1, 1, 1, 0, 1, 1, 1, nil, nil], :evaluation=>0.8571028571028571},
          {:user_id=>44, :array=>[nil, nil, nil, 2, 2, 3, 2, 2, 0, 2, 0, 1, 0, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.7},
          {:user_id=>45, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, nil, nil], :evaluation=>0.7272727272727273},
          {:user_id=>46, :array=>[nil, 2, 2, 3, 2, 1, 2, 2, 2, 0, 2, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.6363636363636360},
          {:user_id=>47, :array=>[1, 2, 2, 2, 2, 2, 2, 0, 1, 1, 2, 2, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>0.8061538061538061},
          {:user_id=>48, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, 0, 0, 0, 0, 0, 0, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>49, :array=>[nil, nil, nil, 2, 2, 2, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0},
          {:user_id=>50, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, nil], :evaluation=>1.0},
          {:user_id=>51, :array=>[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], :evaluation=>1.0}],
        :evaluation=>0.8802093331505096
      }
    ]
  end
end
