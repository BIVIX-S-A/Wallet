class User < ActiveRecord::Base
    enum marital_status: { single: 0, married: 1, divorced: 2, widowed: 3 }
end