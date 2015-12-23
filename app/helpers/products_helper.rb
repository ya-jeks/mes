module ProductsHelper

   def md5(str)
     Digest::MD5.hexdigest str
   end

end
