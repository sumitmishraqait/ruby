require 'net/http'
url='http://http://10.0.1.86/tatoc/advanced/rest/#'
resp=Net::HTTP.get_response(URI.parse(url))
resp_text=resp.body

params={ id=[4655] , signature=["cde525d38aceb7fb31f137bb169116ad"], allow_access=1}
rsp=NET::HTTP.post_form(url,params)

resp_text=resp.body
puts"#{resp_text}"
