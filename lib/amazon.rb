module Amazon

  class Client

    def initialize
      @request = Vacuum.new

      @request.configure({
        aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_KEY'],
        associate_tag:         ENV['ASSOCIATE_TAG']
        })

    end

    # returns array of products
    def call_item_search(keyword)

      rg = %w(ItemAttributes Images ).join(',')
      response = @request.item_search(query: {
        'ItemSearch.Shared.SearchIndex'   => 'FashionWomen',
        'ItemSearch.Shared.Keywords'      => "#{keyword}",
        'ItemSearch.Shared.ResponseGroup' => rg,
        'ItemSearch.1.ItemPage'           => 1
      # 'ItemSearch.2.ItemPage'           => 2
      })

      data = response.to_h
      data["ItemSearchResponse"]["Items"]["Item"]

    end

    def remove_womens_from_name(full_product_name)
      name_array = full_product_name.split(" ")
      if name_array.include?("Women's")
        w_index = name_array.index("Women's")
        name_array.delete_at(w_index)
        new_name = name_array.join(" ")
        return new_name
      end
      return full_product_name
    end

    def remove_brand_from_name(full_product_name, brand)
      brand_array = brand.split(" ")
      name_array = full_product_name.split(" ")
      new_array = []
      name_array.each do |word|
        if brand.include?(word) == false
          new_array << word
        end
      end
      new_name = new_array.join(" ")
      return new_name
    end


    def parse_product_name(full_product_name, brand)
      temp_title = remove_womens_from_name(full_product_name)
      return remove_brand_from_name(temp_title, brand)
    end

    def item_info_hash(product_info_array)
      info_hash = {}
      brand = product_info_array["ItemAttributes"]["Brand"]
      if brand != nil
        info_hash[:product_designer] = brand
      end
      if product_info_array["ItemAttributes"]["Title"] != nil
        info_hash[:product_name] = parse_product_name(product_info_array["ItemAttributes"]["Title"].split(',').first, brand)
      end
      if product_info_array["ItemAttributes"]["ListPrice"]
        info_hash[:product_price] = ((product_info_array["ItemAttributes"]["ListPrice"]["Amount"].to_i) * 0.01)
      end
      if product_info_array["ItemAttributes"]["ProductGroup"]
        info_hash[:product_category] = product_info_array["ItemAttributes"]["ProductGroup"]
      end
      if product_info_array["ItemAttributes"]["DetailPageURL"]
        info_hash[:product_url] = product_info_array["DetailPageURL"]
      end
      # info_hash[:product_description]
      if product_info_array["ImageSets"]["ImageSet"][2] != nil
        info_hash[:product_image] = product_info_array["ImageSets"]["ImageSet"][0]["LargeImage"]["URL"]
      end
      if product_info_array["ImageSets"]["ImageSet"][2] != nil
        info_hash[:product_image_2] = product_info_array["ImageSets"]["ImageSet"][2]["LargeImage"]["URL"]
      end
      if product_info_array["ImageSets"]["ImageSet"][3] != nil
        info_hash[:product_image_3] = product_info_array["ImageSets"]["ImageSet"][3]["LargeImage"]["URL"]
      end
      if product_info_array["ImageSets"]["ImageSet"][4] != nil
        info_hash[:product_image_4] = product_info_array["ImageSets"]["ImageSet"][4]["LargeImage"]["URL"]
      end
      if product_info_array["ASIN"]
        info_hash[:product_ASIN] = product_info_array["ASIN"]
      end
      return info_hash
    end

  end

end


    # def call_item_lookup(item_ASIN_number)
    #   # self.associate_tag = "bumble0b0-20"
    #   response = @request.item_lookup(query: { 'IdType' => 'ASIN', 'ItemId' => "#{item_ASIN_number}"})

    #   data     = response.to_h

    #   #returns array of item data
    #   return data

    # end
