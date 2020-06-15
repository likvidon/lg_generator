require 'yaml'
require 'mongoid'
require 'bunny'
require 'json'

require_relative 'models/user'
require_relative 'functions'

config = YAML.load_file(ARGV[0])
Mongoid.load!((config['db']['mongoid']), :development)


STDOUT.sync = true


x, queue = create_rabbitmq_connect(config)


while true do  #Зацикливаем для постоянного мониторинга
  queue.subscribe do |delivery_info, metadata, payload|
    puts "Полученная последовательность #{payload}"

    task = JSON.parse(payload)

    for i in 0..task['num'].to_i - 1
      login = login_generation
      passwd = password_generation(task['length'], task['complexity'])

      User.create!(login: login, password: passwd)

      puts "User created with login #{login} and passwd #{passwd}"
    end
  end
end
