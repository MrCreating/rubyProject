namespace :user do
  desc "Create a new user"
  task :register => :environment do
    if ARGV.length < 3
      puts "Использование: rake user:register username email password [access_level]"
      exit
    end

    username = ARGV[1]
    email = ARGV[2]
    password = ARGV[3]
    access_level = ARGV[4] || 0

    if username.blank? || email.blank? || password.blank?
      puts "Username, E-mail и Пароль обязательны"
      exit
    end

    existing_user = User.find_by("username = ? OR email = ?", username, email)

    if existing_user
      puts "Пользователь с таким #{existing_user.username == username ? 'именем' : 'email'} уже существует. Удаляем старого пользователя..."
      existing_user.destroy!
      puts "Старый пользователь удален."
    end

    user = User.create!(username: username, email: email, password: password, access_level: access_level)
    puts "Пользователь создан: #{user.username} (ID: #{user.id}) (Email: #{user.email}) с правами доступа уровня #{user.access_level}"
    exit
  end
end