class KvstoragesController < ApplicationController

  before_filter :find_key, only: [:get, :destroy]
  before_filter :find_all_keys, only: [:show_all, :show_id_values]

  def index
    
  end

  #This method render forms for setting a new key, and pass it to method "set"
  def new
   @key = Kvstorage.new 
  end

  def set
    @key = Kvstorage.create(params[:kvstorage])
    p params
    if @key.errors.empty?
      redirect_to action: "index"
    else
      render "new"
    end 
  end

  #This method shows all keys with id and values
  def show_id_values

  end

  #Show all keys
  def show_all
 
  end

  #Show value for selected key
  def get
    @key.increment!(:rating) 
  end

  #Delete selected key from table
  def destroy
    @key.destroy
    redirect_to action: "index" 
  end


  #Mixing values randomly
  def shuffle

      Kvstorage.transaction do
        kvhash = Hash.new
        Kvstorage.select("id, value").each do |q|
          kvhash[q.id] = {"value" => q.value}
        end
        Kvstorage.update(kvhash.keys, kvhash.values.shuffle)
      end
    redirect_to action: "index" 
  end

  #Show all keys in decreasing order
  def stat
   @keys = Kvstorage.order('rating DESC') 
  end

  
  private

#Methods for before filters

    def find_key
      @key = Kvstorage.find(params[:id])
    end

    def find_all_keys
      @keys = Kvstorage.order('id')
    end

end
