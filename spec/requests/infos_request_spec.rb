require 'rails_helper'

RSpec.describe "Infos", type: :request do
    describe 'GET /' do
        it 'render' do
            get '/'
            expect(responce).to have_http_status(200)
        end
    end
end
