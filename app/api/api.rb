class API < Grape::API
       
    format :json

    desc "Get"
    get do
       {hello: "world"} 
    end
end