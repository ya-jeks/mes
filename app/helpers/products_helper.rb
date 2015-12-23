module ProductsHelper

   def as_price(val)
     if val!=0 && val.to_i!=0
       val % val.to_i == 0 ? "#{val.to_i} руб." : "#{val} руб."
     elsif val!=0 && val.to_i==0
       val
     else
       0
     end
   end

   def without_zeros(val)
     if val!=0 && val.to_i!=0
       val % val.to_i == 0 ? val.to_i : val
     elsif val!=0 && val.to_i==0
       val
     else
       0
     end
   end

   def md5(str)
     Digest::MD5.hexdigest str
   end

end
