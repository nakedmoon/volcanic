class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :move]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /tree.json
  # GET /tree
  def tree
    #@categories = (!params[:parent_id].present? || params[:parent_id] == '#') ? Category.roots : Category.find(params[:parent_id]).children
    @categories = Category.all
    respond_to do |format|
      format.json
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
    @category.parent_id = params[:parent_id] || '#'
  end

  # GET /categories/1/edit
  def edit
    respond_to do |format|
      format.json
    end
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.json { render :json => {:message => 'Category was successfully created.', :node => @category.path_ids},
                             :status => :created,
                             :location => @category
        }
      else
        @message = 'Error creating category.'
        format.json { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.json { render :json => {:message => 'Category was successfully updated.'},
                             :status => :ok,
                             :location => @category
        }
      else
        @message = 'Error updating category.'
        format.json { render :edit, status: :unprocessable_entity }
      end
    end
  end


  def move
    respond_to do |format|
      if @category.update(category_params)
        format.json { render :json => {:message => 'Category was successfully updated.'},
                             :status => :ok,
                             :location => @category
        }
      else
        @message = 'Error updating category.'
        format.json { render :json => {:message => 'Error moving category.'},
                             status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    respond_to do |format|
      if @category.destroy
        format.json { render :json => {:message => 'Category was successfully deleted.'},
                             :status => :accepted
        }
      else
        format.json { render :json => {:message => 'Error deleting category.'},
                             :status => :unprocessable_entity

        }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :parent_id)
    end
end
