class NodeTreesController < ApplicationController
  before_action :set_node_tree, only: [:show, :edit, :update, :destroy]

  # GET /node_trees
  # GET /node_trees.json
  def index
    @node_trees = NodeTree.all
  end

  # GET /node_trees/1
  # GET /node_trees/1.json
  def show
  end

  # GET /node_trees/new
  def new
    @node_tree = NodeTree.new
  end

  # GET /node_trees/1/edit
  def edit
  end

  # POST /node_trees
  # POST /node_trees.json
  def create
    @node_tree = NodeTree.new(node_tree_params)

    respond_to do |format|
      if @node_tree.save
        format.html { redirect_to @node_tree, notice: 'Node tree was successfully created.' }
        format.json { render :show, status: :created, location: @node_tree }
      else
        format.html { render :new }
        format.json { render json: @node_tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /node_trees/1
  # PATCH/PUT /node_trees/1.json
  def update
    respond_to do |format|
      if @node_tree.update(node_tree_params)
        format.html { redirect_to @node_tree, notice: 'Node tree was successfully updated.' }
        format.json { render :show, status: :ok, location: @node_tree }
      else
        format.html { render :edit }
        format.json { render json: @node_tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /node_trees/1
  # DELETE /node_trees/1.json
  def destroy
    @node_tree.destroy
    respond_to do |format|
      format.html { redirect_to node_trees_url, notice: 'Node tree was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node_tree
      @node_tree = NodeTree.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def node_tree_params
      params.require(:node_tree).permit(:name)
    end
end
