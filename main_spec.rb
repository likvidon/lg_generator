require 'yaml'
require 'mongoid'
require 'bunny'

require_relative 'models/user'
require_relative 'functions'



describe 'lp_generator' do
  context " must create num objects in DB" do

    it "Create objects with parameters in request" do
      task = {"num":1,"length":10,"role":"admin","complexity":"hard"}

      config = YAML.load_file('settings.yml')    
      Mongoid.load!(config['db']['mongoid'], :development)
      
      users_before = User.count
     
      x, queue = create_rabbitmq_connect(config)
      x.publish(task.to_json, :routing_key => queue.name)
      sleep(2)  #Чтоб успеть создать записи

      users_after = User.count
      
      expect(users_after - users_before).to eq task[:num]
    end
  end
end
