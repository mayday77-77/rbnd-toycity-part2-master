require 'json'

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	# Rubric mentioned : There is a `report.txt` file in the top level directory."
	$report_file = File.new("../report.txt", "w+")
end

# Print "Sales Report" in ascii art
def print_sales_rpt
	return "
  ____        _            ____                       _   
 / ___|  __ _| | ___ ___  |  _ \\ ___ _ __   ___  _ __| |_ 
 \\___ \\ / _` | |/ _ / __| | |_) / _ | '_ \\ / _ \\| '__| __|
  ___) | (_| | |  __\\__ \\ |  _ |  __| |_) | (_) | |  | |_ 
 |____/ \\__,_|_|\\___|___/ |_| \\_\\___| .__/ \\___/|_|   \\__|
                                    |_|                   
===============================================================\n"
end

# Print today's date
def print_date
	today_date = Time.new
	today_date.strftime("\nToday's Date: %d/%m/%Y\n")
end

# Generic method for writing a string to file
def save_file(input_obj)
	$report_file.write(input_obj)
end

# Generic method for writing an array for strings into file
def save_file_array(input_obj_array)
	input_obj_array.each {|each_obj| save_file(each_obj)}
end

# Print "Products" in ascii art
def print_products
	return "
  ____                _            _      
 |  _ \\ _ __ ___   __| |_   _  ___| |_ ___ 
 | |_) | '__/ _ \\ / _` | | | |/ __| __/ __|
 |  __/| | | (_) | (_| | |_| | (__| |_\\__ \\
 |_|   |_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/\n\n"

end                                       

# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
	# Calculate and print the total amount of sales
	# Calculate and print the average price the toy sold for
	# Calculate and print the average discount (% or $) based off the average sales price
# Print the name of the toy
def product_name(array_item)
	array_item["title"]
end

# Print the retail price of the toy
def product_full_price(array_item)
	array_item["full-price"]
end

# Calculate and print the total number of purchases
def product_tot_purchases(array_item)
	array_item["purchases"].length
end	

# Calculate and print the total amount of sales
def product_tot_sales(array_item)
	price_only = array_item["purchases"].map {| my_price | my_price["price"]}
 	price_only.inject(:+)
end

# Calculate and print the average price the toy sold for
def product_avg_price(array_item)
	product_tot_sales(array_item)/product_tot_purchases(array_item)
end

# Calculate average discount price in $
def product_avg_discount(array_item)
	product_full_price(array_item).to_f-product_avg_price(array_item)
end

# Calculate and print the average discount (% or $) based off the average sales price
def product_avg_discount_per(array_item)
	(product_avg_discount(array_item)/product_full_price(array_item).to_f * 100).round(2)
	#avg_price_dis/retail_pr.to_f * 100).round(2)}%"

end

# Print all product details to file
def product_details
	# loop and call on methods for each details
	$products_hash["items"].each do | toy_name |
		save_array = [("\nProduct: "+product_name(toy_name)+"\n**********************************\n"),
						("Retail Price: $"+product_full_price(toy_name)+"\n"),
						("Total Number of Purchases: "+product_tot_purchases(toy_name).to_s+"\n"),
						("Total Sales Amount: $"+product_tot_sales(toy_name).to_s+"\n"),
						("Average Price: $"+product_avg_price(toy_name).to_s+"\n"),
						("Average Discount: $"+product_avg_discount(toy_name).to_s+"\n"),
						("Average Discount Percentage: "+product_avg_discount_per(toy_name).to_s+"%\n")]
		save_file_array(save_array)		
	end
end

# Print "Brands" in ascii art
def print_brands
	return "
  ____                      _     
 | __ ) _ __ __ _ _ __   __| |___ 
 |  _ \\| '__/ _` | '_ \\ / _` / __|
 | |_) | | | (_| | | | | (_| \\__ \\
 |____/|_|  \\__,_|_| |_|\\__,_|___/\n\n"

end
# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined

# Returns the array of unique brand names
def brand_name
	products_brand = ($products_hash["items"].map {|each_brand| each_brand["brand"]}).uniq
end

# Extract the respective stock list for one type of brand
def brand_stock_list(array_item)
	stock_array = $products_hash["items"].select {|item| array_item == item["brand"]}   
end

# Count and print the number of the brand's toys we stock
def brand_stock_number(array_item)
    stock_total = brand_stock_list(array_item).map {| one_stock | one_stock["stock"]}
    stock_total.inject(:+)
end

# Calculate and print the average price of the brand's toys
def brand_avg_price(array_item)
	price_total = brand_stock_list(array_item).map {| one_stock | one_stock["full-price"].to_f}
 	(price_total.inject(:+)/price_total.length).round(2)
end

# Calculate and print the total sales volume of all the brand's toys combined
def brand_tot_sales(array_item)
	total_sales = 0
	brand_stock_list(array_item).each do | each_item | 
		each_item["purchases"].each do | each_item_price |
			total_sales += each_item_price["price"]
		end
	end
	return total_sales.round(2)
end

# Print all brand details to file
def brand_details
	# Calling brand_name method to return the array and start looping
	brand_name.each do |each_brand | 
		# Print the name of the brand on first line
		save_array = [("Brand : #{each_brand}\n**********************************\n"),
					("Number of Products: "+brand_stock_number(each_brand).to_s+"\n"),
					("Average Product Price: $"+brand_avg_price(each_brand).to_s+"\n"),
					("Total Sales: $"+brand_tot_sales(each_brand).to_s+"\n\n")]
		save_file_array(save_array)
	end
end

# main body of creating the reports to file
def create_report
	create_rep_heading
  	create_product_data
  	create_brand_data
end

# create the main header of the report
def create_rep_heading
	save_file(print_date)
	save_file(print_sales_rpt)
end

# main body for creating product data
def create_product_data
	save_file(print_products)
	product_details
end

# main body for creating brand data
def create_brand_data
	save_file(print_brands)
	brand_details
end

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

start # call start method to trigger report generation