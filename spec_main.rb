require_relative 'gemfile'


describe 'lp_generator' do
  context "lp_generator must create num objects in DB" do

    it "Create objects with parameters in request" do
      task = '{"num":2,"length":10,"role":"admin","complexity":"hard"}'

      config = YAML.load(File.read('settings.yml'))      
      Mongoid.load!(File.expand_path(config['db']['mongoid']), :development)
      
      users_before = User.all.length

      x, queue = create_rabbitmq_connect(config)
      x.publish(task, :routing_key => queue.name)
      sleep(2)  #Чтоб успеть создать записи

      users_after = User.all.length
      expect(users_after - users_before).to eq JSON.parse(task)['num']
    end
  end
end
