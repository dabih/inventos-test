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

  #In this commented out part I try to shuffle the values without loops (in mysql database)

#   sql = "CREATE temporary TABLE if not exists `temp_storage` ( `value` text ) ENGINE=InnoDB DEFAULT CHARSET=utf8; DELETE FROM temp_store; INSERT INTO temp_store SELECT `value` FROM kvstorages; UPDATE kvstorages SET `value` = (SELECT `value` FROM temp_store ORDER BY RAND() LIMIT 1);"
#    sql = "CREATE TABLE if not exists `temp_store` ( 
#             `id` int(11) NOT NULL, 
#             `key` text,
#             `value` text,
#             `rating` int(11) default 0,
#             `created_at` datetime NOT NULL,
#             `updated_at` datetime NOT NULL,
#             PRIMARY KEY (`id`)
#           ) ENGINE=InnoDB DEFAULT CHARSET=utf8;" 
#    sql1 = "DELETE FROM temp_store;"
#    sql2 = "INSERT INTO temp_store (SELECT * FROM kvstorages ORDER BY RAND());"
#    sql3 = "REPLACE INTO kvstorages (`value`) SELECT `value` FROM temp_store WHERE temp_store.id=kvstorages.id;"
#    sql3 = "UPDATE kvstorages SET `value` = (SELECT `value` FROM temp_storage ORDER BY RAND() LIMIT 1);"
   

    kvhash = Hash.new
    Kvstorage.select("key, value").each do |q|
      kvhash.merge!Hash[q.key, q.value]
    end

    valarray = kvhash.values.shuffle
    i=0

    kvhash.each_key do |key|
      ActiveRecord::Base.connection.execute("UPDATE kvstorages SET value='#{valarray[i]}' WHERE key='#{key}';")
      i += 1
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
      @keys = Kvstorage.all
    end

end
